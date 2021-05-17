//
//  MealTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/16.
//

import UIKit

class MealTableViewCell: UITableViewCell {

    @IBOutlet weak var dairyFreeButton: UIButton!
    @IBOutlet weak var glutenFreeButton: UIButton!
    @IBOutlet weak var junkFreeButton: UIButton!
    @IBOutlet weak var sugarFreeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        checkAllButtonStatus()
    }
    @IBAction func selectedDairy(_ sender: Any) {
        dairyFreeButton.isSelected = !dairyFreeButton.isSelected
        dairyFreeButton.checkButtonState()
    }
    @IBAction func selectedGluten(_ sender: Any) {
        glutenFreeButton.isSelected = !glutenFreeButton.isSelected
        glutenFreeButton.checkButtonState()
    }
    @IBAction func selectedJunk(_ sender: Any) {
        junkFreeButton.isSelected = !junkFreeButton.isSelected
        junkFreeButton.checkButtonState()
    }
    @IBAction func selectedSugar(_ sender: Any) {
        sugarFreeButton.isSelected = !sugarFreeButton.isSelected
        sugarFreeButton.checkButtonState()
    }
    
    func checkAllButtonStatus() {
        dairyFreeButton.checkButtonState()
        glutenFreeButton.checkButtonState()
        junkFreeButton.checkButtonState()
        sugarFreeButton.checkButtonState()
    }
    
}
