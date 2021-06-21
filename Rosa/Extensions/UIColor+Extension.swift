//
//  UIColor+Extension.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/13.
//

// swiftlint:disable all

import Foundation
import UIKit
import SwiftEntryKit

// MARK: - For challenges background color

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
    
    static func challengeColor(challenge: String) -> UIColor {
        switch challenge {
        case "glutenFree":
            return UIColor.rgb(red: 255, green: 204, blue: 102, alpha: 1)
        case "dairyFree":
            return UIColor.rgb(red: 226, green: 158, blue: 74, alpha: 1)
        case "junkFoodFree":
            return UIColor.rgb(red: 246, green: 200, blue: 141, alpha: 1)
        case "sugarFree":
            return UIColor.rgb(red: 255, green: 163, blue: 135, alpha: 1)
        case "water":
            return UIColor.rgb(red: 137, green: 196, blue: 255, alpha: 1)
        case "sleep":
            return UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 1)
        case "hairOil":
            return UIColor.rgb(red: 78, green: 206, blue: 165, alpha: 1)
        case "spicy":
            return UIColor.rgb(red: 255, green: 104, blue: 132, alpha: 1)
        case"toothpaste":
            return UIColor.rgb(red: 197, green: 153, blue: 255, alpha: 1)
        case "cushion":
            return UIColor.rgb(red: 255, green: 193, blue: 218, alpha: 1)
        case "facialMask":
            return UIColor.rgb(red: 247, green: 172, blue: 143, alpha: 1)
        default:
            return UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 1)
        }
    }
}

// MARK: - For swiftEntryKit

extension UIColor {
    
    static func by(r: Int, g: Int, b: Int, a: CGFloat = 1) -> UIColor {
        let d = CGFloat(255)
        return UIColor(red: CGFloat(r) / d, green: CGFloat(g) / d, blue: CGFloat(b) / d, alpha: a)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    var ekColor: EKColor {
        return EKColor(self)
    }

}

struct Color {
    
    struct Netflix {
        static let light = EKColor(rgb: 0x485563)
        static let dark = EKColor(rgb: 0x29323c)
    }
    
    struct Gray {
        static let a800 = EKColor(rgb: 0x424242)
        static let mid = EKColor(rgb: 0x616161)
        static let light = EKColor(red: 230, green: 230, blue: 230)
    }
    
    struct Teal {
        static let a700 = EKColor(rgb: 0x00bfa5)
        static let a600 = EKColor(rgb: 0x00897b)
    }

    struct LightPink {
        static let first = EKColor(rgb: 0xff0000)
        static let last = EKColor(rgb: 0xfad0c4)
    }
}

