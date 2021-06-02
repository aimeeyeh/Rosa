//
//  RemarkTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/16.
//

import UIKit

class RemarkTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var remarkTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        remarkTextField.delegate = self
    }
    
    var touchHandler: ((String) -> Void)?
    
    var remark: String = "" {
        didSet {
            touchHandler?(remark)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == remarkTextField {
            if let text = remarkTextField.text {
                self.remark = text
                remarkTextField.resignFirstResponder()
            }
        }
    }

    @IBAction func editingChanged(_ sender: UITextField) {
        if let text = sender.text {
            self.remark = text
        }
    }
    
}
