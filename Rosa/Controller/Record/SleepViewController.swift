//
//  SleepViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/19.
//

import UIKit
import HGCircularSlider

class SleepViewController: UIViewController {

    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var bedtimeLabel: UILabel!
    @IBOutlet weak var wakeLabel: UILabel!
    @IBOutlet weak var rangeCircularSlider: RangeCircularSlider!
    
    var sleepAmount = 0.0
    
    lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup O'clock
        rangeCircularSlider.startThumbImage = UIImage(named: "Bedtime")
        rangeCircularSlider.endThumbImage = UIImage(named: "Wake")
        
        let dayInSeconds = 24 * 60 * 60
        rangeCircularSlider.maximumValue = CGFloat(dayInSeconds)
        
        rangeCircularSlider.startPointValue = 1 * 60 * 60
        rangeCircularSlider.endPointValue = 8 * 60 * 60

        updateTexts(rangeCircularSlider!)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func updateTexts(_ sender: Any) {
        adjustValue(value: &rangeCircularSlider.startPointValue)
        adjustValue(value: &rangeCircularSlider.endPointValue)

        let bedtime = TimeInterval(rangeCircularSlider.startPointValue)
        let bedtimeDate = Date(timeIntervalSinceReferenceDate: bedtime)
        bedtimeLabel.text = dateFormatter.string(from: bedtimeDate)
        
        let wake = TimeInterval(rangeCircularSlider.endPointValue)
        let wakeDate = Date(timeIntervalSinceReferenceDate: wake)
        wakeLabel.text = dateFormatter.string(from: wakeDate)
        
        let duration = wake - bedtime
        sleepAmount = duration / 3600
        let durationDate = Date(timeIntervalSinceReferenceDate: duration)
        dateFormatter.dateFormat = "HH:mm"
        durationLabel.text = dateFormatter.string(from: durationDate)
        dateFormatter.dateFormat = "hh:mm a"
    }
    
    var touchHandler: ((Double) -> Void)?
    var onSleepCancelButtonPressed: (() -> Void)?
    var onSleepConfirmButtonPressed: (() -> Void)?
    
    @IBAction func confirmSleep(_ sender: Any) {
        touchHandler?(sleepAmount)
        onSleepConfirmButtonPressed?()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelSleep(_ sender: Any) {
        onSleepCancelButtonPressed?()
        self.navigationController?.popViewController(animated: true)
    }
    
    func adjustValue(value: inout CGFloat) {
        let minutes = value / 60
        let adjustedMinutes =  ceil(minutes / 5.0) * 5
        value = adjustedMinutes * 60
    }
}
