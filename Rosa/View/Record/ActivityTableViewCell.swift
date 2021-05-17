//
//  ActivityTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/16.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var outdoorButton: UIButton!
    @IBOutlet weak var makeupButton: UIButton!
    @IBOutlet weak var menstrualButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        checkAllButtonStatus() 
    }

    @IBAction func selectedOutdoor(_ sender: Any) {
        outdoorButton.isSelected = !outdoorButton.isSelected
        outdoorButton.checkButtonState()
    }

    @IBAction func selectedMakeup(_ sender: Any) {
        makeupButton.isSelected = !makeupButton.isSelected
        makeupButton.checkButtonState()
    }

    @IBAction func selectedMenstrual(_ sender: Any) {
        menstrualButton.isSelected = !menstrualButton.isSelected
        menstrualButton.checkButtonState()
    }
    
    func checkAllButtonStatus() {
        outdoorButton.checkButtonState()
        makeupButton.checkButtonState()
        menstrualButton.checkButtonState()
    }
    
}
