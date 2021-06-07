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

    var touchHandler: ((String) -> Void)?
    var selectedFeeling: String = "" {
        didSet {
            touchHandler?(selectedFeeling)
        }
    }

    @IBAction func selectedHappy(_ sender: Any) {
        happyButton.isSelected = !happyButton.isSelected
        happyButton.checkButtonState()
        selectedFeeling = "Happy"
        if happyButton.isSelected {
            okButton.isSelected = false
            mehButton.isSelected = false
            sadButton.isSelected = false
            angryButton.isSelected = false
            checkAllButtonStatus()
        }
    }

    @IBAction func selectedOk(_ sender: Any) {
        okButton.isSelected = !okButton.isSelected
        okButton.checkButtonState()
        selectedFeeling = "Nice"
        if okButton.isSelected {
            happyButton.isSelected = false
            mehButton.isSelected = false
            sadButton.isSelected = false
            angryButton.isSelected = false
            checkAllButtonStatus()
        }
    }

    @IBAction func selectedMeh(_ sender: Any) {
        mehButton.isSelected = !mehButton.isSelected
        mehButton.checkButtonState()
        selectedFeeling = "Meh"
        if mehButton.isSelected {
            okButton.isSelected = false
            happyButton.isSelected = false
            sadButton.isSelected = false
            angryButton.isSelected = false
            checkAllButtonStatus()
        }
    }

    @IBAction func selectedSad(_ sender: Any) {
        sadButton.isSelected = !sadButton.isSelected
        sadButton.checkButtonState()
        selectedFeeling = "Sad"
        if sadButton.isSelected {
            okButton.isSelected = false
            mehButton.isSelected = false
            happyButton.isSelected = false
            angryButton.isSelected = false
            checkAllButtonStatus()
        }
    }

    @IBAction func selectedAngry(_ sender: Any) {
        angryButton.isSelected = !angryButton.isSelected
        angryButton.checkButtonState()
        selectedFeeling = "Angry"
        if angryButton.isSelected {
            okButton.isSelected = false
            mehButton.isSelected = false
            sadButton.isSelected = false
            happyButton.isSelected = false
            checkAllButtonStatus()
        }
    }
    
    func checkAllButtonStatus() {
        happyButton.checkButtonState()
        okButton.checkButtonState()
        mehButton.checkButtonState()
        sadButton.checkButtonState()
        angryButton.checkButtonState()
    }
    
}
