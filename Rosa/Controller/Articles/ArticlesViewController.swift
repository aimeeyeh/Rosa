//
//  ArticlesViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit
import CollectionViewWaterfallLayout

// struct MockData {
//
//    let title: String
//    let photo: String
//    let arthor: String
//    let likes: Int
// }

class ArticlesViewController: UIViewController {

//    var mockData: [MockData] = []
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var trendingButton: UIButton!
    @IBOutlet weak var recommendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
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
    @IBAction func showCategory(_ sender: Any) {
        tableViewHeight.constant = tableViewHeight.constant == 0 ? 174 : 0
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
          self.tableView.alpha = 1
          self.view.layoutIfNeeded()
        }
    }
}

extension ArticlesViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        50
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                         for: indexPath) as? CollectionViewCell { return cell }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showArticleDetails", sender: self)
    }

}

// MARK: - CollectionViewWaterfallLayoutDelegate

extension ArticlesViewController: CollectionViewWaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
}

extension ArticlesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 43.5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 4
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
}
