//
//  GameListVC.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//

import UIKit

class GameListVC: UIViewController {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var slideStack: UIStackView!
    
    @IBOutlet weak var gameListCollectionView: UICollectionView!
    
    @IBOutlet weak var slideCollectionView: UICollectionView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var filteredGames = [Game]()
    var isFiltering: Bool = false
    var games = [Game](){
        didSet {
            DispatchQueue.main.async {    // DispatchQueue.main.async için  mainde yapması gereken işlemi eşzamansız(asenkron) yürütmesi diyebiliriz.Bir iş öğesini belirtilen zamanda yürütülecek şekilde planlar ve hemen geri döner.
                self.gameListCollectionView.reloadData()
                self.slideCollectionView.reloadData()
            }
            for i in 0...2 {
                slideArray.append(games[i])
            }
        }
    }
    var slideArray = [Game]()
    let gameListRequest = GameListRequest(link: "https://api.rawg.io/api/games?key=60ea7e49d3f64cab81b2607bc917a3b3") //Bu arada request istek demek. Veriyi çağırdığımız istediğimiz sayfa GameListRequest o yüzden onu anımsadık.
    var selectedGame: Game?
    var gameDetails: GameDetailsModel?
    var nextPage = ""
    
    //for pageControl
    var timer = Timer()
    var counter = 0
    var currentPage = 0 { //currentPage&geçerliSayfa
        didSet{
            pageControl.currentPage = currentPage
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideCollectionView.delegate = self
        slideCollectionView.dataSource = self
        
        gameListCollectionView.delegate = self
        gameListCollectionView.dataSource = self
        gameListCollectionView.contentInset = UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
        
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.tintColor = .white
        
        gameListRequest.getGames { result in
            do {
                self.games = try result.get().results!
                self.nextPage = try result.get().next!
            }catch let error {
                print(error)
            }
        }
       
        
        timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(changeSlide), userInfo: nil, repeats: true)
    }
    @objc func changeSlide(){
        if counter < slideArray.count {
            let indexPath = IndexPath(item: counter, section: 0)
            slideCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
            currentPage = counter
            counter += 1
        }else {
            counter = 0
            currentPage = counter
            let indexPath = IndexPath(item: counter, section: 0)
            slideCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = counter
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGameDetails" {
            let destinationVC = segue.destination as! GameDetailsVC
            destinationVC.gameDetails = gameDetails
            destinationVC.selectedGame = selectedGame
        }
    }
 
    func getMoreGameData(){
        let gameListRequest = GameListRequest(link: nextPage)
        gameListRequest.getGames { result in
            do {
                self.games += try result.get().results!
                self.nextPage = try result.get().next!
            }catch let error {
                print(error)
            }
        }
    }
}


extension GameListVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == slideCollectionView {
            return slideArray.count
        }else {
            if isFiltering {
                if filteredGames.count == 0 {
                    gameListCollectionView.backgroundView?.isHidden = false
                }else {
                    gameListCollectionView.backgroundView?.isHidden = true
                }
                slideStack.isHidden = true
                return filteredGames.count
                
            }else{
                gameListCollectionView.backgroundView?.isHidden = true
                return games.count - 3
            }
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == slideCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameSlideCell", for: indexPath) as! GameSlideCell
            
            cell.configure(model: slideArray[indexPath.row])
            
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameListCell", for: indexPath) as! GameListCell
            
            if indexPath.row == games.count - 4{
                getMoreGameData()
            }
            if isFiltering{
                cell.configure(model: filteredGames[indexPath.row])
            }else{
                cell.configure(model: games[indexPath.row + 3])
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == slideCollectionView {
            return CGSize(width: self.view.bounds.width, height: 200)
        }else {
            return CGSize(width: self.view.bounds.width - 10, height: 150 )
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == slideCollectionView {
            selectedGame = games[indexPath.row]
        }else {
            if isFiltering{
                selectedGame = filteredGames[indexPath.row]
            }else{
                selectedGame = games[indexPath.row+3]
            }
        }
        
        let gameDetailsRequest = GameDetailsRequest(slug: (selectedGame?.slug)!)
        gameDetailsRequest.getGameDetails{ result in
            do {
                self.gameDetails = try result.get()
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "goToGameDetails", sender: self)
                }
            }catch let error {
                print(error)
            }
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == gameListCollectionView{
            let width = scrollView.frame.width
            currentPage = Int(scrollView.contentOffset.x / width)
            counter = currentPage
        }
    }
}

extension GameListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        updateSearchResults(searchText: searchText)
    }
    func updateSearchResults(searchText: String) {
        if searchText.count < 3 || searchText.isEmpty {
            slideStack.isHidden = false
            filteredGames.removeAll()
            isFiltering = false
            gameListCollectionView.reloadData()
        }else {
            filteredGames = games.filter({ (gameInfo:Game) -> Bool in
                return gameInfo.name!.lowercased().contains(searchText.lowercased())
            })
            
            isFiltering = true
            gameListCollectionView.reloadData()
        }
        
    }
}
extension GameListVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > gameListCollectionView.contentSize.height - 10 - scrollView.frame.size.height {
        }
    }
}

    
    
    
    
