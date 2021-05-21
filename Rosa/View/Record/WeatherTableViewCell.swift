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
    
    var touchHandler: ((String) -> Void)?
    var selectedWeather: String = "" {
        didSet {
            touchHandler?(selectedWeather)
        }
    }

    @IBAction func selectedSunny(_ sender: Any) {
        sunnyButton.isSelected = !sunnyButton.isSelected
        sunnyButton.checkButtonState()
        selectedWeather = "sunny"
    }
    
    @IBAction func selctedMostlyClear(_ sender: Any) {
        mostlyClearButton.isSelected = !mostlyClearButton.isSelected
        mostlyClearButton.checkButtonState()
        selectedWeather = "mostlyClear"
    }
    
    @IBAction func slectedCloudy(_ sender: Any) {
        cloudyButton.isSelected = !cloudyButton.isSelected
        cloudyButton.checkButtonState()
        selectedWeather = "cloudy"
    }
    
    @IBAction func selectedRainy(_ sender: Any) {
        rainyButton.isSelected = !rainyButton.isSelected
        rainyButton.checkButtonState()
        selectedWeather = "Rainy"
    }

}
