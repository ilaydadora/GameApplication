//
//  CustomImageView.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//


import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
class CustomImageView: UIImageView {
    
    var task: URLSessionDataTask!
    
    
    func loadImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            fatalError("Error")
        }
        
        
        image = nil
       
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            image = imageFromCache
           
            return
        }
        
        
        task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let newImage = UIImage(data: data)
            else {
                print("couldnt load image from url: \(url)")
                return
            }
            
            imageCache.setObject(newImage, forKey: url.absoluteString as AnyObject)
            DispatchQueue.main.async {
                self.image = newImage
               
            }
        }
        
        task.resume()
    }
  
    
        
    }
