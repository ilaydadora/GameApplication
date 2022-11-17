//
//  GameListRequest.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//

import Foundation

enum GameListError: Error {
    case noDataAvailable
    case canNotProcessData
}
struct GameListRequest{
    
    let resourceURL: URL
    
    init(link: String){
        let gameListString = link
        
        //MARK: 1. Create URL
        guard let gameListURL = URL(string: gameListString) else {
            fatalError("Error")
        }
        self.resourceURL = gameListURL
    }
    
    func getGames(completion: @escaping(Result<GameModel, GameListError>) -> Void) {
        //MARK: 2. Create URLSession and Give the session a task
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, response, error in
            guard let jsonData = data else {
                return
            }
            do {
                let decoder = JSONDecoder()
                let games = try decoder.decode(GameModel.self, from: jsonData)
                completion(.success(games))
            }catch{
                print("json decode errror")
            }
        }
        //MARK: 4. Start the task
        dataTask.resume()
    }
}
