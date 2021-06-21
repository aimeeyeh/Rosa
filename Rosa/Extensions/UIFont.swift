//
//  UIFont.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/2.
//

import UIKit

typealias MainFont = Font.HelveticaNeue

enum Font {
    enum HelveticaNeue: String {
        case medium = "Medium"
        case light = "Light"
        
        func with(size: CGFloat) -> UIFont {
            return UIFont(name: "HelveticaNeue-\(rawValue)", size: size)!
        }
    }
}
