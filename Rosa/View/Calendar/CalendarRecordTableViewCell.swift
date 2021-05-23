//
//  CalenderRecordTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/22.
//

import UIKit

class CalendarRecordTableViewCell: UITableViewCell {

    @IBOutlet weak var recordBackground: UIView!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var waterLabel: UILabel!
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var feelingImage: UIImageView!
    @IBOutlet weak var feelingLabel: UILabel!
    @IBOutlet weak var glutenFreeLabel: UILabel!
    @IBOutlet weak var dairyFreeLabel: UILabel!
    @IBOutlet weak var junkFreeLabel: UILabel!
    @IBOutlet weak var sugarFreeLabel: UILabel!
    @IBOutlet weak var outdoorLabel: UILabel!
    @IBOutlet weak var makeupLabel: UILabel!
    @IBOutlet weak var menstrualLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        recordBackground.layer.masksToBounds = true
    }
    
    func configure(record: Record) {
        self.weatherImage.image = UIImage(named: record.weather)
        self.weatherLabel.text = record.weather
        self.waterLabel.text = "\(record.water*250) ml"
        self.sleepLabel.text = "\(record.sleep.rounded()) hours"
        self.feelingImage.image = UIImage(named: record.feeling)
        self.feelingLabel.text = record.feeling
        
        if record.mealGlutenFree {
            glutenFreeLabel.textColor = .white
        } else {
            glutenFreeLabel.textColor = .black
        }
        
        if record.mealDairyFree {
            dairyFreeLabel.textColor = .white
        } else {
            dairyFreeLabel.textColor = .black
        }
        
        if record.mealJunkFree {
            junkFreeLabel.textColor = .white
        } else {
            junkFreeLabel.textColor = .black
        }
        
        if record.mealSugarFree {
            sugarFreeLabel.textColor = .white
        } else {
            sugarFreeLabel.textColor = .black
        }
        
        if record.outdoor {
            outdoorLabel.textColor = .white
        } else {
            outdoorLabel.textColor = .black
        }
        
        if record.makeup {
            makeupLabel.textColor = .white
        } else {
            makeupLabel.textColor = .black
        }
        
        if record.menstrual {
            menstrualLabel.textColor = .white
        } else {
            menstrualLabel.textColor = .black
        }
        
    }
    
    
}
