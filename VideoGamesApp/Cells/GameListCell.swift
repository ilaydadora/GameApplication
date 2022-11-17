//
//  GameListCell.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//

import UIKit

class GameListCell: UICollectionViewCell {
    
    @IBOutlet weak var gameImg: CustomImageView!
    
    
    @IBOutlet weak var starLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    @IBOutlet weak var gameNameLabel: UILabel!
    
    func configure(model: Game) {
        
        self.releaseDateLabel.changeDateFormat(str: model.released!)
        self.gameNameLabel.text = model.name
        self.ratingLabel.text = "\(model.rating!)"
        self.starLabel.text = String(repeating: " ⭐", count: Int(model.rating!))
        self.gameImg.loadImage(from: model.background_image!)
        
        self.layer.borderWidth = 0.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
        
    }
    
    
}

