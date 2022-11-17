//
//  GameDetailsVC.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//

import UIKit

class GameDetailsVC: UIViewController {
    
    @IBOutlet weak var gameImg: CustomImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var genreLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var metaCriticLabel: UILabel!
    
    @IBOutlet weak var gameNameLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var gameDescriptionLabel: UILabel!
    
    
    
    var gameDetails: GameDetailsModel?
    var selectedGame: Game?
    var allGenre = ""
    var photos = [String]()
    var text = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for ss in (selectedGame?.short_screenshots)!{
            photos.append(ss.image!)
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        
        configure()
        changeFavImg()
        
    }
    func configure(){
        gameDescriptionLabel.text = gameDetails?.description_raw
        dateLabel.changeDateFormat(str: (gameDetails?.released)!)
        text = String((gameDetails?.metacritic) ?? 0)
        metaCriticLabel.text = "Metacritic: " + text
        gameNameLabel.text = gameDetails?.name
        gameImg.loadImage(from: (gameDetails?.background_image)!)
        let genres = (gameDetails?.genres)!
        for genre in genres{
            allGenre += " \(genre.name!)"
        }
        genreLabel.text = "Genre: " + allGenre
    }
    func changeFavImg(){
        if FavoriteGame.sharedIntance.favoriteGames.contains(gameDetails!){
            favoriteButton.setImage(UIImage.init(systemName: "suit.heart.fill"), for: .normal)
        }else{
            favoriteButton.setImage(UIImage.init(systemName: "suit.heart"), for: .normal)
        }
    }
    func addToFavorite(){
        FavoriteGame.sharedIntance.favoriteGames.append(gameDetails!)
        FavoriteGame.sharedIntance.favoriteGameImages.append(selectedGame!)
        favoriteButton.setImage(UIImage.init(systemName: "suit.heart.fill"), for: .normal)
    }
    func deleteFromFavorite(){
        let tempArray = FavoriteGame.sharedIntance.favoriteGames.filter{ $0 != gameDetails}
        FavoriteGame.sharedIntance.favoriteGames = tempArray
        favoriteButton.setImage(UIImage.init(systemName: "suit.heart"), for: .normal)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToSlide" {
            let destinationVC = segue.destination as! PhotoSlideVC
            destinationVC.selectedGame = selectedGame
        }else if segue.identifier == "goToPopUp" {
            let destinationVC = segue.destination as! ConfirmVC
            destinationVC.delegate = self
        }
    }
    
    
    @IBAction func favoriteButtonClicked(_ sender: UIButton) {
        
        if FavoriteGame.sharedIntance.favoriteGames.contains(gameDetails!){
            self.performSegue(withIdentifier: "goToPopUp", sender: self)
        }else {
            addToFavorite()
        }
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension GameDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        cell.configure(img: photos[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "goToSlide", sender: self)
    }
}

extension GameDetailsVC: FavoriteDelegate {
    func sendChoose(choose: Bool) {
        if choose == true{
            deleteFromFavorite()
        }else{
            return
        }
    }
}

