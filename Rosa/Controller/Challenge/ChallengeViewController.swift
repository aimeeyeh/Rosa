//
//  ChallengeViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit

protocol EmployeePickerDelegate: AnyObject {
    func employeeAssigned()
}

class ChallengeViewController: UIViewController {

    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: EmployeePickerDelegate?

    let blackView = UIView(frame: UIScreen.main.bounds)
    
    var selectedChallenges: [Challenge] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        collectionView.allowsMultipleSelection = true
        configureView()
    }
    
    func configureView() {
        blackView.backgroundColor = .black
        blackView.alpha = 0
        blackView.tag = 100
        presentingViewController?.view.addSubview(blackView)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            self.blackView.alpha = 0.5
        }
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
        delegate?.employeeAssigned()
//        dismiss(animated: true, completion: nil)
        blackView.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
        for index in 0..<selectedChallenges.count {
            
            ChallengeManager.shared.postChallenge(challenge: &selectedChallenges[index]) { result in
                
                switch result {
                
                case .success:
                    
                    print("onTapUpdateChallenge, success")
        
                case .failure(let error):
                    
                    print("onTapUpdateChallenge, failure: \(error)")
                }
            }
        }
    }
    
}

extension ChallengeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChallengeManager.shared.defaultChallenges.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeCollectionViewCell",
                                                         for: indexPath) as? ChallengeCollectionViewCell {
            cell.configureChallenge(indexPath: indexPath)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let challenges = ChallengeManager.shared.defaultChallenges
        let category = challenges[indexPath.row].category
        let challengeImage = challenges[indexPath.row].challengeImage
        let challengeTitle = challenges[indexPath.row].challengeTitle
        selectedChallenges.append(Challenge(category: category,
                                            challengeImage: challengeImage,
                                            id: "didselect",
                                            progress: 0,
                                            setUpDate: Date(),
                                            challengeTitle: challengeTitle, isFirstDay: false, isChecked: false))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let challenges = ChallengeManager.shared.defaultChallenges
        let challengeTitle = challenges[indexPath.row].challengeTitle
        let index = selectedChallenges.firstIndex {
            $0.challengeTitle == challengeTitle
        }
        selectedChallenges.remove(at: index!)
    }
    
}
