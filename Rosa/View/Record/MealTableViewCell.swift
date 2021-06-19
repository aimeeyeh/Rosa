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
    
    var touchHandler: (([Bool]) -> Void)?
    
    var mealStatus: [Bool] = [false, false, false, false] {
        didSet {
            touchHandler?(mealStatus)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkAllButtonStatus()
    }
    
    func checkAllButtonStatus() {
        dairyFreeButton.checkButtonState()
        glutenFreeButton.checkButtonState()
        junkFreeButton.checkButtonState()
        sugarFreeButton.checkButtonState()
    }
    
    @IBAction func selectedDairy(_ sender: Any) {
        dairyFreeButton.isSelected = !dairyFreeButton.isSelected
        dairyFreeButton.checkButtonState()
        if dairyFreeButton.isSelected {
            mealStatus[0] = true
        } else {
            mealStatus[0] = false
        }
    }
    
    @IBAction func selectedGluten(_ sender: Any) {
        glutenFreeButton.isSelected = !glutenFreeButton.isSelected
        glutenFreeButton.checkButtonState()
        if glutenFreeButton.isSelected {
            mealStatus[1] = true
        } else {
            mealStatus[1] = false
        }
    }
    
    @IBAction func selectedJunk(_ sender: Any) {
        junkFreeButton.isSelected = !junkFreeButton.isSelected
        junkFreeButton.checkButtonState()
        if junkFreeButton.isSelected {
            mealStatus[2] = true
        } else {
            mealStatus[2] = false
        }
    }
    
    @IBAction func selectedSugar(_ sender: Any) {
        sugarFreeButton.isSelected = !sugarFreeButton.isSelected
        sugarFreeButton.checkButtonState()
        if sugarFreeButton.isSelected {
            mealStatus[3] = true
        } else {
            mealStatus[3] = false
        }
    }
    
}
