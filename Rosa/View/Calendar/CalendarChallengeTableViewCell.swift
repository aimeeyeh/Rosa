//
//  CalendarChallengeTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/18.
//

import UIKit

class CalendarChallengeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var challengeBackground: UIView!
    @IBOutlet weak var challengeImage: UIImageView!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var challengeTitle: UILabel!
    @IBOutlet weak var challengeDesciption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func checkChallenge(_ sender: Any) {
        checkboxButton.isSelected = !checkboxButton.isSelected
    }
    
    func addShadow() {
        challengeBackground.layer.cornerRadius = 20.0
        challengeBackground.layer.shadowColor = UIColor.darkGray.cgColor
        challengeBackground.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        challengeBackground.layer.shadowRadius = 1.0
        challengeBackground.layer.shadowOpacity = 0.7
        challengeBackground.layer.masksToBounds = false
    }

}
