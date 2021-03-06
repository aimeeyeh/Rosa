//
//  ChallengeViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit

protocol RecordConfirmedDelegate: AnyObject {
    func onConfirmBtnPressed()
}

class ChallengeViewController: UIViewController {
    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tutorialButton: UIButton!
    
    weak var delegate: RecordConfirmedDelegate?
    
    let blackView = UIView(frame: UIScreen.main.bounds)
    
    let defaultChallenges =  ChallengeManager.shared.defaultChallenges
    
    var selectedChallenges: [Challenge] = []
    
    var currentDoingChallengesTitle: [String] = [] {
        didSet {
            availableChallenges = defaultChallenges.filter {
                !(currentDoingChallengesTitle.contains($0.challengeTitle))
            }
        }
    }
    
    var availableChallenges: [ChallengeManager.DefaultChallenge] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        collectionView.allowsMultipleSelection = true
        configureTutorialBtn()
        configureView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchCurrentDoingChallenges()
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
    
    func configureTutorialBtn() {
        tutorialButton.setTitle("What is this?".localized(), for: .normal)
        tutorialButton.setTitleColor(.lightGray, for: .normal)
        tutorialButton.underlineText()
    }
    
    @IBAction func cancelChallenge(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        blackView.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func confirmChallenge(_ sender: Any) {
        delegate?.onConfirmBtnPressed()
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
    
    func fetchCurrentDoingChallenges() {
        ChallengeManager.shared.fetchChallenge(date: Date()) { [weak self] result in
            
            switch result {
            
            case .success(let challenges):
                
                for challenge in challenges {
                    self?.currentDoingChallengesTitle.append(challenge.challengeTitle.localized())
                }
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
    
}

extension ChallengeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentDoingChallengesTitle.isEmpty {
            return defaultChallenges.count
        } else {
            return availableChallenges.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChallengeCollectionViewCell",
                                                         for: indexPath) as? ChallengeCollectionViewCell {
            
            if currentDoingChallengesTitle.isEmpty {
                cell.configureChallenge(challenges: defaultChallenges, indexPath: indexPath)
            } else {
                cell.configureChallenge(challenges: availableChallenges, indexPath: indexPath)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        var category = ""
        var challengeImage = ""
        var challengeTitle = ""
        
        func configureSelectedChallenge(challenges: [ChallengeManager.DefaultChallenge]) {
            let challenge = challenges[indexPath.row]
            category = challenge.category
            challengeImage = challenge.challengeImage
            challengeTitle = challenge.challengeTitle
        }
        
        if currentDoingChallengesTitle.isEmpty {
            configureSelectedChallenge(challenges: defaultChallenges)
            
        } else {
            configureSelectedChallenge(challenges: availableChallenges)
        }
        
        selectedChallenges.append(
            Challenge(category: category, challengeImage: challengeImage, id: "didselect", progress: 0,
                      setUpDate: Date(), challengeTitle: challengeTitle, isFirstDay: false, isChecked: false))
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {

        var challengeTitle = ""
        
        if currentDoingChallengesTitle.isEmpty {
            let extractedExpr = defaultChallenges[indexPath.row]
            challengeTitle = extractedExpr.challengeTitle
            
        } else {
            challengeTitle = availableChallenges[indexPath.row].challengeTitle
        }
        
        let index = selectedChallenges.firstIndex {
            $0.challengeTitle == challengeTitle
        }
        selectedChallenges.remove(at: index!)
    }
    
}
