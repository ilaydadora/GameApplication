//
//  ConfirmVC.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//

import UIKit

protocol FavoriteDelegate {
    func sendChoose(choose: Bool)
}
class ConfirmVC: UIViewController {
    
    var delegate: FavoriteDelegate?
    var choose = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func yesButtonClicked(_ sender: Any) {
        choose = true
        self.delegate?.sendChoose(choose: choose)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        
        choose = false
        self.delegate?.sendChoose(choose: choose)
        self.dismiss(animated: true, completion: nil)
        
    }
    

}
