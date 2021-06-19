//
//  CalendarChallengeTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/18.
//

import UIKit

class CalendarChallengeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var challengeBackgroundView: UIView!
    @IBOutlet weak var challengeImage: UIImageView!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var challengeTitleLabel: UILabel!
    @IBOutlet weak var challengeDesciptionLabel: UILabel!
    
    var onButtonPressed: (() -> Void)?
    
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
        challengeTitleLabel.text = title.localized()
        challengeTitleLabel.textColor = .white
        challengeDesciptionLabel.text = "Skincare is Healthcare".localized()
        challengeDesciptionLabel.textColor = .systemGray6
        challengeBackgroundView.backgroundColor = UIColor.challengeColor(challenge: imageNmae)
        checkboxButton.isUserInteractionEnabled = !challenges[indexPath.row].isChecked
        checkboxButton.isSelected = challenges[indexPath.row].isChecked
    }
    
    func noRecordConfigure() {
        checkboxButton.isHidden = true
        challengeImage.image = UIImage(named: "information")
        challengeTitleLabel.text = "No Record...".localized()
        challengeTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        challengeDesciptionLabel.text = "Let's go add some records!".localized()
        challengeDesciptionLabel.textColor = .white
        challengeTitleLabel.textColor = .white
        challengeBackgroundView.backgroundColor = .systemGray2
    }
    
    func noChallengeConfigure() {
        checkboxButton.isHidden = true
        challengeImage.image = UIImage(named: "information")
        challengeTitleLabel.text = "No Challenges...".localized()
        challengeTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        challengeDesciptionLabel.text = "Let's go add some challenges!".localized()
        challengeDesciptionLabel.textColor = .label
        challengeTitleLabel.textColor = .label
        challengeBackgroundView.backgroundColor = .systemGray6
    }
    
    func addShadow() {
        challengeBackgroundView.layer.cornerRadius = 20.0
        challengeBackgroundView.layer.shadowColor = UIColor.darkGray.cgColor
        challengeBackgroundView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        challengeBackgroundView.layer.shadowRadius = 1.0
        challengeBackgroundView.layer.shadowOpacity = 0.7
        challengeBackgroundView.layer.masksToBounds = false
    }
    
}
