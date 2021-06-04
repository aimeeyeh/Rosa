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
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    @IBOutlet weak var followedNumber: UILabel!
    @IBOutlet weak var followersNumber: UILabel!
    @IBOutlet weak var postedArticlesNumber: UILabel!
    
    var currentType = "postedArticles"
    
    var postedArticles: [Article] = [] {
        didSet {
            collectionView.reloadData()
            configureNumbers()
        }
    }
    
    var likedArticles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setRightBarButton(nil, animated: true)
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchPostedArticles()
        fetchLikedArticles()
    }
    
    func fetchPostedArticles() {
        
        ArticleManager.shared.fetchPostedArticles { [weak self] result in
            
            switch result {
            
            case .success(let articles):
                
                self?.postedArticles = articles
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
    
    func configureNumbers() {
        postedArticlesNumber.text = "\(postedArticles.count)"
        let followers = UserManager.shared.currentUser?.followers?.count ?? 0
        let followed = UserManager.shared.currentUser?.followed?.count ?? 0
        followedNumber.text = "\(followed)"
        followersNumber.text = "\(followers)"
    }
    
    func fetchLikedArticles() {
        
        ArticleManager.shared.fetchLikedArticles { [weak self] result in
            
            switch result {
            
            case .success(let articles):
                
                self?.likedArticles = articles
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
        
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
                collectionView.reloadData()
            default:
                currentType = "likedArticles"
                collectionView.reloadData()
            }
        }
        
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if currentType == "postedArticles" {
            return postedArticles.count
        } else {
            return likedArticles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCollectionViewCell",
                                                        for: indexPath) as? ArticleCollectionViewCell {
            if currentType == "postedArticles" {
                cell.configure(article: postedArticles[indexPath.row])
            } else {
                cell.configure(article: likedArticles[indexPath.row])
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let articleDetailVC = UIStoryboard(name: "Articles", bundle: nil).instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
            if currentType == "postedArticles" {
                articleDetailVC.article = postedArticles[indexPath.row]
            } else {
                articleDetailVC.article = likedArticles[indexPath.row]
            }
            self.navigationController?.pushViewController(articleDetailVC, animated: true)
        }
    }

}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
           return UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10)
        }
}
