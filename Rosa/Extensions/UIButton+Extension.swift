//
//  UIButton+Extension.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/16.
//

import UIKit

@IBDesignable
extension UIButton {
    
    // Border Color
    @IBInspectable var buttonBorderColor: UIColor? {
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
    @IBInspectable var buttonBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    // Corner radius
    @IBInspectable var buttonCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    func checkButtonState() {
        if self.isSelected {
            self.alpha = 1
        } else {
            self.alpha = 0.3
        }
    }
    
    func underlineText() {
        guard let title = title(for: .normal) else { return }
        
        let titleString = NSMutableAttributedString(string: title)
        titleString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(titleString, for: .normal)
    }
    
}
