//
//  ImageCache.swift
//  PokedexProjectJSON
//
//  Created by Field Employee on 12/13/20.
//

import Foundation

final class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSURL, NSData>()
    private init(){}
    
    func saveImageData(data: Data, with url: URL) {
        self.cache.setObject(data as NSData, forKey: url as NSURL)
    }
    
    func getImageData(from url: URL) -> Data? {
        return self.cache.object(forKey: url as NSURL) as Data?
    }
}
