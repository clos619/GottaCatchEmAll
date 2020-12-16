//
//  PokemonTableViewCell.swift
//  PokedexProjectJSON
//
//  Created by Field Employee on 12/13/20.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    @IBOutlet weak var pokemonImageView: UIImageView!
    @IBOutlet weak var pokemonTextLabel: UILabel!
    
    @IBOutlet weak var typeLabel: UILabel!
    var pokemonType :[Type] =  []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with pokemon: Pokemon) {
        
        self.pokemonTextLabel.text = pokemon.name
        self.pokemonType.append(contentsOf: pokemon.types)
        
//        let pokemonCount = ViewController()
//        let pokeCount = pokemonCount.pokemonArray.count
            self.typeLabel.text = pokemonType[0].name
        
        NetworkManager.shared.getImageData(from: (pokemon.sprites.frontDefault)!) { (data, error) in
            guard let data = data else {return}
            DispatchQueue.main.async {
                self.pokemonImageView.image = UIImage(data: data)
                self.pokemonImageView.layoutIfNeeded()
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
