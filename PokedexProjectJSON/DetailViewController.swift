//
//  DetailViewController.swift
//  PokedexProjectJSON
//
//  Created by Field Employee on 12/15/20.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var myPokemon: Pokemon!
    
    @IBOutlet weak var detailImage: UIImageView!
    @IBOutlet weak var detailPokeName: UILabel!
    @IBOutlet weak var detailID: UILabel!
    @IBOutlet weak var detailWeight: UILabel!
    @IBOutlet weak var detailBaseExp: UILabel!
    @IBOutlet weak var detailHeight: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    var pokemonMoves: [Moves] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pokemonMoves.append(contentsOf: myPokemon.allMoves)
        self.movesLabel.text = "Moves: \(pokemonMoves[0].move ?? "loading")"
        self.detailPokeName.text = myPokemon.name.capitalized
        self.detailID.text = "ID: \(myPokemon.id)"
        self.detailWeight.text = "Weight: \(myPokemon.weight)"
        self.detailBaseExp.text = "Base EXP: \(myPokemon.baseExp)"
        self.detailHeight.text = "Height: \(myPokemon.height)"
        NetworkManager.shared.getImageData(from: myPokemon.sprites.frontDefault!) {(data, error) in
        guard let data = data else {return}
        DispatchQueue.main.async {
            self.detailImage.image = UIImage(data: data)
            }
        }
    }
}
