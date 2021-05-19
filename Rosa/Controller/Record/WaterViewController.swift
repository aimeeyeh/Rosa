//
//  WaterViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/19.
//

import UIKit

class WaterViewController: UIViewController {
    
    let blackView = UIView(frame: UIScreen.main.bounds)
    var glassAmount = 0 {
        didSet {
            let waterAmount = glassAmount * 250
            waterLabel.text = "\(waterAmount) ml / 2500 ml"
        }
    }
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var waterLabel: UILabel!
    
    @IBAction func tappedGlass(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        sender.checkButtonState()
        if sender.isSelected {
            glassAmount += 1
        } else {
            glassAmount -= 1
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        let waterAmount = glassAmount * 250
        waterLabel.text = "\(waterAmount) ml / 2000 ml"

    }
    
    func addBlackView() {
        
        blackView.backgroundColor = .black
        blackView.alpha = 0
        blackView.tag = 100
        presentingViewController?.view.addSubview(blackView)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            self.blackView.alpha = 0.5
            
        }
    }
    
    func configureView() {
        
        addBlackView()
        popUpView.layer.cornerRadius = 15
        cancelButton.clipsToBounds = true
        cancelButton.layer.cornerRadius = 15
        cancelButton.layer.maskedCorners = [.layerMinXMaxYCorner]
        saveButton.clipsToBounds = true
        saveButton.layer.cornerRadius = 15
        saveButton.layer.maskedCorners = [.layerMaxXMaxYCorner]
        // Top right corner, Top left corner respectively
        
    }
    
    @IBAction func cancelWater(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        blackView.removeFromSuperview()
    }
    @IBAction func confirmWater(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        blackView.removeFromSuperview()
    }

}
