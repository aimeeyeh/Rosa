//
//  UIColor+Extension.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/13.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static func challengeColor(challenge: String) -> UIColor {
        switch challenge {
        case "Gluten Free":
            return UIColor.rgb(red: 246, green: 200, blue: 141, alpha: 1)
        case "Dairy Free":
            return UIColor.rgb(red: 226, green: 158, blue: 74, alpha: 1)
        case "Junk Free":
            return UIColor.rgb(red: 246, green: 200, blue: 141, alpha: 1)
        case "Sugar Free":
            return UIColor.rgb(red: 255, green: 163, blue: 135, alpha: 1)
        case "Water":
            return UIColor.rgb(red: 137, green: 196, blue: 255, alpha: 1)
        case "Sleep":
            return UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 1)
        case "Hair Oil":
            return UIColor.rgb(red: 78, green: 206, blue: 165, alpha: 1)
        case "No Spicy":
            return UIColor.rgb(red: 255, green: 104, blue: 132, alpha: 1)
        case"Toothpaste":
            return UIColor.rgb(red: 197, green: 153, blue: 255, alpha: 1)
        case "No cusion":
            return UIColor.rgb(red: 255, green: 193, blue: 218, alpha: 1)
        case "Facial Mask":
            return UIColor.rgb(red: 247, green: 172, blue: 143, alpha: 1)
        default:
            return UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        }
        
    }
}
