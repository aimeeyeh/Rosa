//
//  ProfileViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var postedButton: UIButton!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var likedButton: UIButton!
    
    var currentType = "postedArticles"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        postedButton.isSelected = false
        likedButton.isSelected = false
        sender.isSelected = !sender.isSelected
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.center.x = sender.center.x + 16
        }
        
        if sender.isSelected {
            switch sender {
            case postedButton:
                currentType = "postedArticles"
            default:
                currentType = "likedArticles"
            }
        }
        
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell",
                                                        for: indexPath) as? ArticleCollectionViewCell {
            return cell
        }
        return UICollectionViewCell()
    }

}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 60) / 2
        return CGSize(width: width, height: width * 1.3)
    }
}
