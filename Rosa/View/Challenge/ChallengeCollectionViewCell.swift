//
//  ChallengeCollectionViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/17.
//

import UIKit

class ChallengeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundCircle: UIImageView!
    @IBOutlet weak var challengeLabel: UILabel!
    @IBOutlet weak var challengeImage: UIImageView!
    
    func configureChallenge(indexPath: IndexPath) {
        let challenges = ChallengeManager.shared.defaultChallenges
        backgroundCircle.backgroundColor = challenges[indexPath.row].backgroundColor
        challengeImage.image = UIImage(named: challenges[indexPath.row].challengeImage)
        challengeImage.alpha = 0.3
        challengeLabel.text = challenges[indexPath.row].challengeTitle

    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                challengeImage.alpha = 1
                backgroundCircle.alpha = 1
                challengeLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
                challengeLabel.backgroundColor = .systemGray5

            } else {
                challengeImage.alpha = 0.5
                backgroundCircle.alpha = 0.5
                challengeLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.caption1)
                challengeLabel.backgroundColor = .clear
            }
        }
    }

}
