//
//  ViewController.swift
//  PokedexProjectJSON
//
//  Created by Field Employee on 12/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pokemonTableView: UITableView!
    @IBOutlet weak var pokemonImageView: UIImageView?
    @IBOutlet weak var pokemonTextLabel: UILabel?
    var pokemonArray: [Pokemon] = []
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pokemonTableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "PokemonTableViewCell")
        self.pokemonTableView.dataSource = self
        self.pokemonTableView.delegate = self
        self.pokemonTableView.prefetchDataSource = self
        self.getAllPokemon()
}

    func createPokemonURL() -> String {
        let apiLink = "https://pokeapi.co/api/v2/pokemon/"
        return apiLink
    }
    
    private func getAllPokemon() {
        let group = DispatchGroup()
        for i in 1...151 {
            group.enter()
            let iString = "\(i)"
            NetworkManager.shared.getDecodedObject(from: self.createPokemonURL() + iString) {
                (pokemon: Pokemon?, error) in
                guard let pokemon = pokemon else {return}
                self.pokemonArray.append(pokemon)
                group.leave()
            }
        }
        group.notify(queue: .main) {
            self.pokemonTableView.reloadData()
        }
    }

    private func generateAlert(from error: Error) -> UIAlertController {
        let alert = UIAlertController(title: "Error", message: "We ran into an Error Description: \(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        return alert
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pokemonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonTableViewCell", for: indexPath) as! PokemonTableViewCell
        cell.configure(with: self.pokemonArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailVCSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndexPath = indexPath.row - 1
        if indexPath.row == lastIndexPath {
            pokemonTableView.reloadData()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            destination.myPokemon = pokemonArray[pokemonTableView.indexPathForSelectedRow!.row]
        }
    }
}

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let lastIndexPath = IndexPath(row: self.pokemonArray.count - 1, section: 0)
        guard indexPaths.contains(lastIndexPath) else {return}
        DispatchQueue.main.async {
           self.pokemonTableView.reloadData()
        }
    }
}


