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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    var onButtonPressed: (() -> Void)?
    var cancelButtonPressed:  (() -> Void)?

    @IBAction func cancelRecord(_ sender: Any) {
        cancelButtonPressed?()
    }
    @IBAction func confirmRecord(_ sender: Any) {
        onButtonPressed?()
    }
    
}
