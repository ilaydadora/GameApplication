//
//  UIViewExtension.swift
//  VideoGamesApp
//
//  Created by İlayda Metin on 11.11.2022.
//


import Foundation
import UIKit

extension UIView{
   @IBInspectable var cornerRadius: CGFloat {
       get{return self.cornerRadius}
        set{
            self.layer.cornerRadius = newValue
        }
    }
    @IBInspectable var shadowColor: UIColor?{
            set {
                guard let uiColor = newValue else { return }
                layer.shadowColor = uiColor.cgColor
            }
            get{
                guard let color = layer.shadowColor else { return nil }
                return UIColor(cgColor: color)
            }
        }

        @IBInspectable var shadowOpacity: Float{
            set {
                layer.shadowOpacity = newValue
            }
            get{
                return layer.shadowOpacity
            }
        }

        @IBInspectable var shadowOffset: CGSize{
            set {
                layer.shadowOffset = newValue
            }
            get{
                return layer.shadowOffset
            }
        }

        @IBInspectable var shadowRadius: CGFloat{
            set {
                layer.shadowRadius = newValue
            }
            get{
                return layer.shadowRadius
            }
        }
    

}

