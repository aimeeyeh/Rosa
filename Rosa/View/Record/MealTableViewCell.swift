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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
