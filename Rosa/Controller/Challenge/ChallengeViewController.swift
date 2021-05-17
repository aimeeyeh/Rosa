//
//  ChallengeViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit

class ChallengeViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let blackView = UIView(frame: UIScreen.main.bounds)

    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        configureView()

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
        cancelButton.buttonCornerRadius = 18
        confirmButton.buttonCornerRadius = 18
        titleView.clipsToBounds = true
        titleView.layer.cornerRadius = 15
        titleView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        // Top right corner, Top left corner respectively
        
    }
    @IBAction func cancelChallenge(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        blackView.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
    }
    @IBAction func confirmChallenge(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        blackView.removeFromSuperview()
    }
}

extension ChallengeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeCollectionViewCell",
                                                        for: indexPath) as? ChallengeCollectionViewCell {
            return cell
        }
        return UICollectionViewCell()
    }
    
}
