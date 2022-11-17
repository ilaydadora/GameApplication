//
//  FavoritesVC.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//

import UIKit

class FavoritesVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedGameDetails: GameDetailsModel?
    var selectedGame: Game?
    var filteredGames = [GameDetailsModel]()
    var favoriteGameImages = [Game]()
    var isFiltering: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        collectionView.register(UINib(nibName: "FavoritesCell", bundle: nil), forCellWithReuseIdentifier: "FavoritesCell")
        
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.tintColor = .white

    }
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameDetails" {
            let destinationVC = segue.destination as! GameDetailsVC
            destinationVC.gameDetails = selectedGameDetails
            destinationVC.selectedGame = selectedGame
        }
    }

}

extension FavoritesVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFiltering {
            if filteredGames.count == 0 {
                collectionView.backgroundView?.isHidden = false
            }else {
                collectionView.backgroundView?.isHidden = true
            }
            return filteredGames.count
                
        }else{
            if FavoriteGame.sharedIntance.favoriteGames.count == 0 {
                collectionView.backgroundView?.isHidden = true
            }else{
                collectionView.backgroundView?.isHidden = true
            }
            
            return FavoriteGame.sharedIntance.favoriteGames.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoritesCell", for: indexPath) as! FavoritesCell
        
        if isFiltering{
            cell.configure(model: filteredGames[indexPath.row])
        }else{
            cell.configure(model: FavoriteGame.sharedIntance.favoriteGames[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width - 10, height: 150 )
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFiltering{
            selectedGameDetails = filteredGames[indexPath.row]
            selectedGame = favoriteGameImages[indexPath.row]
            print("deneme 5")
        }else{
            selectedGame = FavoriteGame.sharedIntance.favoriteGameImages[indexPath.row]
            selectedGameDetails = FavoriteGame.sharedIntance.favoriteGames[indexPath.row]
        }
        self.performSegue(withIdentifier: "goToGameDetails", sender: self)
    }
}

extension FavoritesVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResults(searchText: searchText)
    }
    func updateSearchResults(searchText: String) {
     
        if searchText.isEmpty {
            filteredGames.removeAll()
            isFiltering = false
            collectionView.reloadData()
           
        }else{
            filteredGames = FavoriteGame.sharedIntance.favoriteGames.filter({ (gameInfo:GameDetailsModel) -> Bool in
              
                return gameInfo.name!.lowercased().contains(searchText.lowercased())
                    })
            
            isFiltering = true
            collectionView.reloadData()
       
        }
    }
}


