//
//  ViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit
import CollectionViewWaterfallLayout

class MainViewController: UIViewController {

    @IBOutlet weak var homeCollectionView: UICollectionView!

    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setUpWaterfall()

    }

    lazy var cellSizes: [CGSize] = {
        var cellSizes = [CGSize]()
        for _ in 0...5 {
            let random = Int(arc4random_uniform((UInt32(100))))
            cellSizes.append(CGSize(width: 200, height: 200 + random))
        }
        return cellSizes
    }()

    func setUpWaterfall() {

        let layout = CollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.headerInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        layout.headerHeight = 80
        layout.minimumColumnSpacing = 10
        layout.minimumInteritemSpacing = 10

        homeCollectionView.collectionViewLayout = layout

    }

}

extension MainViewController: UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell",
                                                        for: indexPath) as? HomeCollectionViewCell {
            cell.shadowDecorate()
            return cell

        }
        return UICollectionViewCell()
    }

}

// MARK: - CollectionViewWaterfallLayoutDelegate

extension MainViewController: CollectionViewWaterfallLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        layout: UICollectionViewLayout,
                        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
}
