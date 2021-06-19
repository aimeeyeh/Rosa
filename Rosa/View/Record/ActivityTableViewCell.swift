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
    
    var touchHandler: (([Bool]) -> Void)?
    
    var activityStatus: [Bool] = [false, false, false] {
        didSet {
            touchHandler?(activityStatus)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkAllButtonStatus() 
    }
    
    func checkAllButtonStatus() {
        outdoorButton.checkButtonState()
        makeupButton.checkButtonState()
        menstrualButton.checkButtonState()
    }
    
    @IBAction func selectedOutdoor(_ sender: Any) {
        outdoorButton.isSelected = !outdoorButton.isSelected
        outdoorButton.checkButtonState()
        if outdoorButton.isSelected {
            activityStatus[0] = true
        } else {
            activityStatus[0] = false
        }
    }
    
    @IBAction func selectedMakeup(_ sender: Any) {
        makeupButton.isSelected = !makeupButton.isSelected
        makeupButton.checkButtonState()
        if makeupButton.isSelected {
            activityStatus[1] = true
        } else {
            activityStatus[1] = false
        }
    }
    
    @IBAction func selectedMenstrual(_ sender: Any) {
        menstrualButton.isSelected = !menstrualButton.isSelected
        menstrualButton.checkButtonState()
        if menstrualButton.isSelected {
            activityStatus[2] = true
        } else {
            activityStatus[2] = false
        }
    }
    
}
