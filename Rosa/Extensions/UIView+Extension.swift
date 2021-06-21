//
//  UIView+Extension.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit

@IBDesignable
extension UIView {

    // Border Color
    @IBInspectable var lkBorderColor: UIColor? {
        get {

            guard let borderColor = layer.borderColor else {

                return nil
            }

            return UIColor(cgColor: borderColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }

    // Border width
    @IBInspectable var lkBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    // Corner radius
    @IBInspectable var lkCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func shadowDecorate() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 25.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.7
    }
    
}
