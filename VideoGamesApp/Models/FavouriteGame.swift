//
//  FavouriteGame.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//


//MARK: singleton class

import Foundation
import UIKit

class FavoriteGame {
    static let sharedIntance = FavoriteGame()
    var favoriteGames = [GameDetailsModel]()
    var favoriteGameImages = [Game]()
    
}
