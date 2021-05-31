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
    }
    
    var onButtonPressed: (() -> Void)?

    @IBAction func checkChallenge(_ sender: Any) {
        checkboxButton.isEnabled = false
        checkboxButton.setImage(UIImage(named: "checked"), for: .disabled)
        onButtonPressed?()
    }
    
    func challengeConfigure(challenges: [Challenge], indexPath: IndexPath) {
        challengeImage.image = UIImage(named: challenges[indexPath.row].challengeImage)
        let title = challenges[indexPath.row].challengeTitle
        challengeTitle.text = title
        challengeTitle.textColor = .white
        challengeDesciption.text = "Skincare is Healthcare"
        challengeDesciption.textColor = .systemGray6
        challengeBackground.backgroundColor = UIColor.challengeColor(challenge: title)
        checkboxButton.setImage(UIImage(named: "unchecked"), for: .normal)
        checkboxButton.setImage(UIImage(named: "checked"), for: .selected)
        checkboxButton.isUserInteractionEnabled = !challenges[indexPath.row].isChecked
        checkboxButton.isSelected = challenges[indexPath.row].isChecked
       
    }
    
    func noRecordConfigure() {
        checkboxButton.setImage(nil, for: .normal)
        checkboxButton.setImage(nil, for: .selected)
        challengeImage.image = UIImage(named: "information")
        challengeTitle.text = "No Record..."
        challengeTitle.font = UIFont.boldSystemFont(ofSize: 16)
        challengeTitle.textColor = .white
        challengeDesciption.text = "Let's go add some records!"
        challengeDesciption.textColor = .white
        challengeBackground.backgroundColor = .systemGray2
    }

    func noChallengeConfigure() {
        checkboxButton.setImage(nil, for: .normal)
        checkboxButton.setImage(nil, for: .selected)
        challengeImage.image = UIImage(named: "information")
        challengeTitle.text = "No Challenges..."
        challengeTitle.font = UIFont.boldSystemFont(ofSize: 16)
        challengeTitle.textColor = .label
        challengeDesciption.text = "Let's go add some challenges!"
        challengeDesciption.textColor = .label
        challengeBackground.backgroundColor = .systemGray6
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
