//
//  PokeCell.swift
//  Pokedex
//
//  Created by Brian Lim on 8/7/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
//    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 7.0 // Set the corner radius of the cell
    }
    
    func configureCell(_ pokemon: Pokemon) {
//        self.pokemon = pokemon
        
        nameLbl.text = pokemon.name.capitalized
        thumbImg.image = UIImage(named: "\(pokemon.pokedexID)")
    }
}
