//
//  RoutineTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/16.
//

import UIKit

class RoutineTableViewCell: UITableViewCell {

    @IBOutlet weak var waterButton: UIButton!
    @IBOutlet weak var sleepButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        waterButton.checkButtonState()
        sleepButton.checkButtonState()

    }

//    @IBAction func selectedWater(_ sender: Any) {
//        waterButton.isSelected = !waterButton.isSelected
//        waterButton.checkButtonState()
//    }
    
//    @IBAction func selectedSleep(_ sender: Any) {
//        sleepButton.isSelected = !sleepButton.isSelected
//        sleepButton.checkButtonState()
//    }
    
}
