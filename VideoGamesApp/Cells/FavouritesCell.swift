//
//  FavouritesCell.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//

import UIKit

class FavouritesCell: UICollectionViewCell {
    
    
    @IBOutlet weak var gameImg: CustomImageView!
    
    @IBOutlet weak var favDate: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var relasedDate: UILabel!
    
    @IBOutlet weak var gameNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: GameDetailsModel){
        self.gameNameLabel.text = model.name
        self.gameImg.loadImage(from: model.background_image!)
        self.ratingLabel.text = "MetaCritic: " + String((model.metacritic)!)
        self.relasedDate.changeDateFormat(str: model.released!)
        self.favDate.text = createDate()
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        self.contentView.layer.cornerRadius = 10
        self.contentView.clipsToBounds = true
        
    }
    func createDate() -> String{
        let today = Date()
        let date = Calendar.current.component(.day, from: today)
        let month = Calendar.current.component(.month, from: today)
        let year = Calendar.current.component(.year, from: today)
        return "Favorite Date: \(date).\(month).\(year)"
    }
    

}


