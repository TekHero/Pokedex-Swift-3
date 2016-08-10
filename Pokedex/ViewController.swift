//
//  ViewController.swift
//  Pokedex
//
//  Created by Brian Lim on 8/7/16.
//  Copyright © 2016 codebluapps. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        
        searchBar.returnKeyType = .done
        
        initAudio()
        parsePokemonCSV()
    }
    
    func initAudio() {
        
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        
        do {
            
            musicPlayer = try AVAudioPlayer(contentsOf: URL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1 // Play forever
            
        } catch let err as NSError {
            
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        
        // 1. Get the path to the pokemon csv file
        let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")!
        
        do {
            
            // 2. Store the contents of the CSV file into the constant
            let csv = try CSV(contentsOfURL: path)
            // 3. Store the rows of the CSV file into the constant
            let rows = csv.rows
            
            // 4. Iterate through the rows in the constant
            for row in rows {
                
                // 5. Get the current poke ID of the current iteration and the name as well for the current iteration
                let pokeID = Int(row["id"]!)!
                let name = row["identifier"]!
                
                // 6. Create a pokemon object and pass in the name an ID for the current iteration
                let poke = Pokemon(name: name, pokedexID: pokeID)
                
                // 7. Add the newly created pokemon into the array of the pokemons
                pokemons.append(poke)
            }

        } catch let err as NSError {
                
            print(err.debugDescription)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
            
            var pokemon: Pokemon!
            
            if inSearchMode {
                
                pokemon = filteredPokemons[indexPath.row]
                cell.configureCell(pokemon)
                
            } else {
                
                pokemon = pokemons[indexPath.row]
                cell.configureCell(pokemon)
            }
            
            return cell
            
        } else {
            
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var poke: Pokemon!
        
        // Check if search mode is active or not
        if inSearchMode {
            
            poke = filteredPokemons[indexPath.row]
            
        } else {
            
            poke = pokemons[indexPath.row]
        }
        
        // Perform the segue and pass in the poke variable in the sender, so that the detailVC gets the correct data
        performSegue(withIdentifier: "PokemonDetailVC", sender: poke)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Check if search mode is active or not
        if inSearchMode {
            
            // if so, then return the amount of pokemons in the filteredPokemons array
            return filteredPokemons.count
        }
        
        // If not, then return the amount of pokemons in the regular pokemons array
        return pokemons.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 100, height: 100)
    }

    @IBAction func musicBtnPressed(_ sender: UIButton) {
        
        if musicPlayer.isPlaying  {
            musicPlayer.pause()
            sender.alpha = 1.0
            
        } else {
            
            initAudio()
            musicPlayer.play()
            sender.alpha = 0.2
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        // Check to see if there is nothing in the search bar
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            collection.reloadData()
            view.endEditing(true)
            
        } else {
            
            inSearchMode = true
            
            let lower = searchBar.text!.lowercased()
            
            /*
             
             $0 - refers to the objects in the pokemon array
             name - refers to the name of string of the object in the array
             range - refers to the range of characters in the name
 
            */
            
            filteredPokemons = pokemons.filter({$0.name.range(of: lower) != nil})
            collection.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Check if the segue's identifier is equal to PokemonDetailVC
        if segue.identifier == "PokemonDetailVC" {
            
            // Check if the segue's destination VC is equal to the PokemonDetailVC
            if let detailsVC = segue.destination as? PokemonDetailVC {
                
                // Check if there is something in the sender that is of type Pokemon object
                if let poke = sender as? Pokemon {
                    
                    // Access the pokemon variable in the detailVC and set it to the pokemon that is being passed over in the sender
                    detailsVC.pokemon = poke
                }
            }
        }
    }
}
















