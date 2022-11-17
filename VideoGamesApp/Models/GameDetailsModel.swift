//
//  GameDetailsModel.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//

import Foundation

struct GameDetailsModel: Decodable, Equatable {
    static func == (lhs: GameDetailsModel, rhs: GameDetailsModel) -> Bool {
        return lhs.name == rhs.name
    }
    
    var id: Int?
    var slug: String?
    var name: String?
    var description_raw: String?
    var metacritic: Int?
    var background_image: String?
    var released: String?
    var genres: [Genre]?
}

struct Genre: Decodable{
    let name: String?
}
