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
        underlineView.backgroundColor = UIColor(red: 1.00, green: 0.84, blue: 0.64, alpha: 1.00)
        setUpWaterfall()
        followButton.isSelected = true
        followButton.setTitleColor(UIColor.orange, for: .selected)

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

        followButton.setTitleColor(UIColor.orange, for: .selected)
        trendingButton.setTitleColor(UIColor.orange, for: .selected)
        recommendButton.setTitleColor(UIColor.orange, for: .selected)

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
}

extension ArticlesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        50
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                         for: indexPath) as? CollectionViewCell { return cell }
        return UICollectionViewCell()
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
