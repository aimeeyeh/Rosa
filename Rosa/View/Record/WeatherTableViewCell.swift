//
//  WeatherTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/16.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var sunnyButton: UIButton!
    @IBOutlet weak var mostlyClearButton: UIButton!
    @IBOutlet weak var cloudyButton: UIButton!
    @IBOutlet weak var rainyButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
