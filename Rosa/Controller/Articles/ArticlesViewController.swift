//
//  ArticlesViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit
import CollectionViewWaterfallLayout

class ArticlesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var trendingButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var postArticleButton: UIButton!
    
    var allArticles: [Article] = []
    
    var blockedUsers: [String] = [] {
        didSet {
            filterBlockedArticles()
        }
    }
    
    var filteredArticles: [Article] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var followedList: [String] = [] {
        didSet {
            followedArticles = filteredArticles.filter { followedList.contains($0.authorID) }
        }
    }
    
    var followedArticles: [Article] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var selectedIndexPath: IndexPath?
    
    var currentType = "allArticles"
    
    // waterfall cell size
    lazy var cellSizes: [CGSize] = {
        var cellSizes = [CGSize]()
        for _ in 0...100 {
            let random = Int(arc4random_uniform((UInt32(100))))
            cellSizes.append(CGSize(width: 200, height: 290 + random))
        }
        return cellSizes
    }()

    override func viewDidLoad() {

        super.viewDidLoad()
        appendShadow()
        self.navigationController?.isNavigationBarHidden = true
        underlineView.backgroundColor = UIColor.gray
        setUpWaterfall()
        trendingButton.isSelected = true
        trendingButton.setTitleColor(UIColor.darkGray, for: .selected)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewHeight.constant = 0
        fetchAllArticles()
        fetchFollowedList()
        self.currentType = "allArticles"
        reloadArticles()

    }
    
    func appendShadow() {
        postArticleButton.layer.shadowColor = UIColor.black.cgColor
        postArticleButton.layer.shadowRadius = 2.0
        postArticleButton.layer.shadowOpacity = 0.1
        postArticleButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        postArticleButton.layer.masksToBounds = false
    }

    func setUpWaterfall() {
        let layout = CollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
    }
    
    @IBAction func showPostArticlePage(_ sender: Any) {
        if let postArticleVC = UIStoryboard(name: "Record", bundle: nil).instantiateViewController(withIdentifier: "PostViewController") as? PostViewController {
            self.navigationController?.pushViewController(postArticleVC, animated: true)
        }
    }
    
    // MARK: - fetch following authors' articles and filter out blocked user's articles
    
    func fetchAllArticles() {
        
        ArticleManager.shared.fetchAllArticles { [weak self] result in
            
            switch result {
            
            case .success(let articles):
                
                self?.allArticles = articles
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
    
    func fetchFollowedList() {
        if let currentUser = UserManager.shared.currentUser {
            if let followed = currentUser.followed {
                self.followedList = followed
            }
            
        }
    }
    
    func reloadArticles() {
        UserManager.shared.fetchUser { result in
            
            switch result {
            
            case .success(let user):
                self.fetchAllArticles()
                self.fetchFollowedList()
                self.fetchBlocklist()
                print(user)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
        
    }
    
    func fetchBlocklist() {
        if let currentUser = UserManager.shared.currentUser {
            blockedUsers = currentUser.blocklist ?? []
        }
    }
    
    func filterBlockedArticles() {
        self.filteredArticles = allArticles.filter { !blockedUsers.contains($0.authorID)}
    }
    
    // MARK: - 熱門/追蹤/推薦

    @IBAction func buttonPressed(_ sender: UIButton) {
        
        followButton.isSelected = false
        
        trendingButton.isSelected = false
        
        sender.isSelected = !sender.isSelected

//        followButton.setTitleColor(UIColor.darkGray, for: .selected)
//        trendingButton.setTitleColor(UIColor.darkGray, for: .selected)
//        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.center.x = sender.center.x + 16
        }

        if sender.isSelected {
            switch sender {
            case followButton:
                currentType = "followed"
                reloadArticles()
                collectionView.reloadData()

            default:
                currentType = "allArticles"
                reloadArticles()
                collectionView.reloadData()

            }
        }
//        reloadData()
    }
    
    // MARK: - 文章分類
    
    @IBAction func showCategory(_ sender: Any) {
        tableViewHeight.constant = tableViewHeight.constant == 0 ? 217.5 : 0
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
          self.tableView.alpha = 1
          self.view.layoutIfNeeded()
        }
    }
}

extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 43.5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      if let cell = tableView.dequeueReusableCell(withIdentifier: "FilterTableViewCell",
                                                  for: indexPath) as? FilterTableViewCell {
        cell.setTitle(index: indexPath.row)
        cell.selectionStyle = .none
        return cell
      }
      return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let queryArray = [
            "酒糟",
            "保養",
            "戒斷",
            "防曬",
            "醫美"
        ]
        
        ArticleManager.shared.queryCategory(category: queryArray[indexPath.row]) { [weak self] result in
            
            switch result {
            
            case .success(let articles):
                
                self?.allArticles = articles
                
                self?.fetchBlocklist()
                
                self?.tableViewHeight.constant = 0
            
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
    
}

// MARK: - 基本文章陳列

extension ArticlesViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if currentType == "allArticles" {
            return filteredArticles.count
        } else {
            return followedArticles.count
        }
        
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell",
                                                         for: indexPath) as? CollectionViewCell {
            
            if currentType == "allArticles" {
                cell.configureArticleCell(article: filteredArticles[indexPath.row])
                return cell
                
            } else {
                cell.configureArticleCell(article: followedArticles[indexPath.row])
                return cell
            }
            
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
        performSegue(withIdentifier: "showArticleDetails", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? ArticleDetailViewController {
            if let indexPath = selectedIndexPath {
                if segue.identifier == "showArticleDetails" {
                    if currentType == "allArticles" {
                        controller.article = self.filteredArticles[indexPath.row]
                        
                    } else {
                        controller.article = self.followedArticles[indexPath.row]
                    }
                }
            }
        }
    }
    
}

// MARK: - CollectionViewWaterfallLayoutDelegate (文章陳列 - waterfall layout 設定）

extension ArticlesViewController: CollectionViewWaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
}
