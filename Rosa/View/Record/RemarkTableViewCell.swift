//
//  RemarkTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/16.
//

import UIKit

class RemarkTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var remarkTextField: UITextField!
    
    var touchHandler: ((String) -> Void)?
    
    var remark: String = "" {
        didSet {
            touchHandler?(remark)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        remarkTextField.delegate = self
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == remarkTextField {
            guard let text = remarkTextField.text else { return }
            self.remark = text
            remarkTextField.resignFirstResponder()
        }
    }
    
    @IBAction func editingChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        self.remark = text
    }
    
}
