//
//  UIColor+Extension.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/13.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
