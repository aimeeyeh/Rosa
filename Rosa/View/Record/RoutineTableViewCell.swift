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
    
}
