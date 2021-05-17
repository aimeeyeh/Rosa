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

        sunnyButton.checkButtonState()
        mostlyClearButton.checkButtonState()
        cloudyButton.checkButtonState()
        rainyButton.checkButtonState()

    }

    @IBAction func selectedSunny(_ sender: Any) {
        sunnyButton.isSelected = !sunnyButton.isSelected
        sunnyButton.checkButtonState()
    }
    
    @IBAction func selctedMostlyClear(_ sender: Any) {
        mostlyClearButton.isSelected = !mostlyClearButton.isSelected
        mostlyClearButton.checkButtonState()
    }
    
    @IBAction func slectedCloudy(_ sender: Any) {
        cloudyButton.isSelected = !cloudyButton.isSelected
        cloudyButton.checkButtonState()
    }
    
    @IBAction func selectedRainy(_ sender: Any) {
        rainyButton.isSelected = !rainyButton.isSelected
        rainyButton.checkButtonState()
    }

}
