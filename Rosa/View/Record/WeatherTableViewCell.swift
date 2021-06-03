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
        checkAllButtonStatus()
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
        if sunnyButton.isSelected {
            mostlyClearButton.isSelected = false
            cloudyButton.isSelected = false
            rainyButton.isSelected = false
            checkAllButtonStatus()
        }
    }
    
    @IBAction func selctedMostlyClear(_ sender: Any) {
        mostlyClearButton.isSelected = !mostlyClearButton.isSelected
        mostlyClearButton.checkButtonState()
        selectedWeather = "mostlyClear"
        if mostlyClearButton.isSelected {
            sunnyButton.isSelected = false
            cloudyButton.isSelected = false
            rainyButton.isSelected = false
            checkAllButtonStatus()
        }
    }
    
    @IBAction func slectedCloudy(_ sender: Any) {
        cloudyButton.isSelected = !cloudyButton.isSelected
        cloudyButton.checkButtonState()
        selectedWeather = "cloudy"
        if cloudyButton.isSelected {
            mostlyClearButton.isSelected = false
            sunnyButton.isSelected = false
            rainyButton.isSelected = false
            checkAllButtonStatus()
        }
    }
    
    @IBAction func selectedRainy(_ sender: Any) {
        rainyButton.isSelected = !rainyButton.isSelected
        rainyButton.checkButtonState()
        selectedWeather = "rainy"
        if rainyButton.isSelected {
            mostlyClearButton.isSelected = false
            cloudyButton.isSelected = false
            sunnyButton.isSelected = false
            checkAllButtonStatus()
        }
    }
    
    func checkAllButtonStatus() {
        sunnyButton.checkButtonState()
        mostlyClearButton.checkButtonState()
        cloudyButton.checkButtonState()
        rainyButton.checkButtonState()
    }

}
