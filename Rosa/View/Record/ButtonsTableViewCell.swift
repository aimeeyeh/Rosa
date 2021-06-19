//
//  ButtonsTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/17.
//

import UIKit

class ButtonsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    
    var onConfirmButtonPressed: (() -> Void)?
    
    var onCancelButtonPressed:  (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func cancelRecord(_ sender: Any) {
        onCancelButtonPressed?()
    }
    @IBAction func confirmRecord(_ sender: Any) {
        onConfirmButtonPressed?()
    }
    
}
