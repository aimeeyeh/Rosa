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
        checkboxButton.setImage(UIImage(named: "checked"), for: .disabled)
        checkboxButton.setImage(UIImage(named: "unchecked"), for: .normal)
        checkboxButton.setImage(UIImage(named: "checked"), for: .selected)

    }
    
    override func prepareForReuse() {
        checkboxButton.isSelected = false
        checkboxButton.isUserInteractionEnabled = true
        checkboxButton.isHidden = false
        checkboxButton.setImage(UIImage(named: "checked"), for: .disabled)
        checkboxButton.setImage(UIImage(named: "unchecked"), for: .normal)
        checkboxButton.setImage(UIImage(named: "checked"), for: .selected)
        
    }
    
    var onButtonPressed: (() -> Void)?

    @IBAction func checkChallenge(_ sender: Any) {
        checkboxButton.isUserInteractionEnabled = false
        checkboxButton.isSelected = true
        onButtonPressed?()
        checkboxButton.setImage(UIImage(named: "checked"), for: .disabled)
        checkboxButton.setImage(UIImage(named: "unchecked"), for: .normal)
        checkboxButton.setImage(UIImage(named: "checked"), for: .selected)
    }
    
    func challengeConfigure(challenges: [Challenge], indexPath: IndexPath) {
        let imageNmae = challenges[indexPath.row].challengeImage
        challengeImage.image = UIImage(named: imageNmae)
        let title = challenges[indexPath.row].challengeTitle
        challengeTitle.text = title.localized()
        challengeTitle.textColor = .white
        challengeDesciption.text = "Skincare is Healthcare".localized()
        challengeDesciption.textColor = .systemGray6
        challengeBackground.backgroundColor = UIColor.challengeColor(challenge: imageNmae)
        checkboxButton.isUserInteractionEnabled = !challenges[indexPath.row].isChecked
        checkboxButton.isSelected = challenges[indexPath.row].isChecked
       
    }
    
    func noRecordConfigure() {
        checkboxButton.isHidden = true
        challengeImage.image = UIImage(named: "information")
        challengeTitle.text = "No Record...".localized()
        challengeTitle.font = UIFont.boldSystemFont(ofSize: 16)
        challengeDesciption.text = "Let's go add some records!".localized()
        challengeDesciption.textColor = .white
        challengeTitle.textColor = .white
        challengeBackground.backgroundColor = .systemGray2
    }

    func noChallengeConfigure() {
        checkboxButton.isHidden = true
        challengeImage.image = UIImage(named: "information")
        challengeTitle.text = "No Challenges...".localized()
        challengeTitle.font = UIFont.boldSystemFont(ofSize: 16)
        challengeDesciption.text = "Let's go add some challenges!".localized()
        challengeDesciption.textColor = .label
        challengeTitle.textColor = .label
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
