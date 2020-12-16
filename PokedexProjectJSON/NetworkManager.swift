//
//  NetworkManager.swift
//  PokedexProjectJSON
//
//  Created by Field Employee on 12/13/20.
//

import Foundation

final class NetworkManager {
    
    enum NetworkError: Error {
        case invalidURLString
        case badData
    }
    
    static let shared = NetworkManager()
    
    private init(){}
    
    func getDecodedObject<T: Decodable>(from urlString: String, completion: @escaping (T?,Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil, NetworkError.invalidURLString)
            return
        }
        
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(decodedObject, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
    
    func getImageData(from url: URL, completion: @escaping(Data?, Error?) -> Void) {
        if let imageData = ImageCache.shared.getImageData(from: url) {
            completion(imageData, nil)
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data { ImageCache.shared.saveImageData(data: data, with: url)
                
            }
            completion(data, error)
        }.resume()
    }
}
