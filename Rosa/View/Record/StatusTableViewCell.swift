//
//  StatusTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/16.
//

import UIKit

class StatusTableViewCell: UITableViewCell {

    @IBOutlet weak var happyButton: UIButton!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var mehButton: UIButton!
    @IBOutlet weak var sadButton: UIButton!
    @IBOutlet weak var angryButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        checkAllButtonStatus()
    }

    @IBAction func selectedHappy(_ sender: Any) {
        happyButton.isSelected = !happyButton.isSelected
        happyButton.checkButtonState()
    }

    @IBAction func selectedOk(_ sender: Any) {
        okButton.isSelected = !okButton.isSelected
        okButton.checkButtonState()
    }

    @IBAction func selectedMeh(_ sender: Any) {
        mehButton.isSelected = !mehButton.isSelected
        mehButton.checkButtonState()
    }

    @IBAction func selectedSad(_ sender: Any) {
        sadButton.isSelected = !sadButton.isSelected
        sadButton.checkButtonState()
    }

    @IBAction func selectedAngry(_ sender: Any) {
        angryButton.isSelected = !angryButton.isSelected
        angryButton.checkButtonState()
    }
    
    func checkAllButtonStatus() {
        happyButton.checkButtonState()
        okButton.checkButtonState()
        mehButton.checkButtonState()
        sadButton.checkButtonState()
        angryButton.checkButtonState()
    }
    
}
