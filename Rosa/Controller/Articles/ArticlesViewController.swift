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
    @IBOutlet weak var recommendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    var allArticles: [Article] = [] {
        didSet {
            collectionView.reloadData()
            print(" 目前有這些： \(allArticles.count)")
        }
    }
    
    // waterfall cell size
    lazy var cellSizes: [CGSize] = {
        var cellSizes = [CGSize]()
        for _ in 0...100 {
            let random = Int(arc4random_uniform((UInt32(100))))
            cellSizes.append(CGSize(width: 200, height: 300 + random))
        }
        return cellSizes
    }()

    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        underlineView.backgroundColor = UIColor.gray
        setUpWaterfall()
        followButton.isSelected = true
        followButton.setTitleColor(UIColor.darkGray, for: .selected)
        fetchAllArticles()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableViewHeight.constant = 0

    }

    func setUpWaterfall() {
        let layout = CollectionViewWaterfallLayout()
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10
        collectionView.collectionViewLayout = layout
    }
    
    func fetchAllArticles() {
        ArticleManager.shared.fetchAllArticles() { [weak self] result in
            
            switch result {
            
            case .success(let articles):
                
                self?.allArticles = articles
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
    
    // MARK: - 熱門/追蹤/推薦
    
    var currentType = "follow"

    @IBAction func buttonPressed(_ sender: UIButton) {

        followButton.isSelected = false
        trendingButton.isSelected = false
        recommendButton.isSelected = false
        sender.isSelected = !sender.isSelected

        followButton.setTitleColor(UIColor.darkGray, for: .selected)
        trendingButton.setTitleColor(UIColor.darkGray, for: .selected)
        recommendButton.setTitleColor(UIColor.darkGray, for: .selected)

        UIView.animate(withDuration: 0.3) {
//            print("self.underlineView.center.x: \(self.underlineView.center.x)")
//            print("sender.center.x: \(sender.center.x)")
            self.underlineView.center.x = sender.center.x + 16
        }

        if sender.isSelected {
            switch sender {
            case followButton:
                currentType = "follow"
            case trendingButton:
                currentType = "trending"
            default:
                currentType = "recommend"
            }
        }
//        reloadData()
    }
    
    // MARK: - 文章分類
    
    @IBAction func showCategory(_ sender: Any) {
        tableViewHeight.constant = tableViewHeight.constant == 0 ? 261 : 0
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
      return 6
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
            "熱門",
            "酒糟",
            "保養",
            "戒斷",
            "防曬",
            "醫美"
        ]
        
        if indexPath.row == 0 {
    
            self.tableViewHeight.constant = 0
            fetchAllArticles()
            tableView.reloadData()
            
        } else {
            
            ArticleManager.shared.queryCategory(category: queryArray[indexPath.row]) { [weak self] result in
                
                switch result {
                
                case .success(let articles):
                    
                    self?.allArticles = articles
                    
                    self?.tableViewHeight.constant = 0
                    
                    tableView.reloadData()
                    
                case .failure(let error):
                    
                    print("fetchData.failure: \(error)")
                }
            }
        }
    }
    
}

// MARK: - 基本文章陳列

extension ArticlesViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        allArticles.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                         for: indexPath) as? CollectionViewCell {
            cell.configureArticleCell(article: allArticles[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showArticleDetails", sender: self)
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

