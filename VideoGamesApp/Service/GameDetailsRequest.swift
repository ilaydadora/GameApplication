//
//  GameDetailsRequest.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//

import Foundation

enum GameDetailsError: Error {
    case noDataAvailable
    case canNotProcessData
}
struct GameDetailsRequest {
    let resourceURL: URL
    
    init(slug: String){
        print("slug:\(slug)")
        let gameDetailsString = "https://api.rawg.io/api/games/\(slug)?key=60ea7e49d3f64cab81b2607bc917a3b3"
        //MARK: 1. Create URL
        guard let gameDetails = URL(string: gameDetailsString) else {
            fatalError("Error")
        }
        self.resourceURL = gameDetails
    }
    
    func getGameDetails(completion: @escaping(Result<GameDetailsModel, GameDetailsError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, response, error in
            guard let jsonData = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let details = try decoder.decode(GameDetailsModel.self, from: jsonData)
                completion(.success(details))
                
            }catch{
                print("json decode errror")
            }
        }
        dataTask.resume()
    }
}
