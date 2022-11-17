//
//  PhotoCell.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//

import UIKit

class PhotoCell: UICollectionViewCell {
        
    
    @IBOutlet weak var photo: CustomImageView!
    
    
    func configure(img: String){
        photo.loadImage(from: img)
    }
}

