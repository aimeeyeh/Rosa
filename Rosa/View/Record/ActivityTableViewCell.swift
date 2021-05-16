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
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
