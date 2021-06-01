//
//  PhotoTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/19.
//
// swiftlint:disable all

import UIKit
import Kingfisher

class PhotoCell: UITableViewCell {

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var photoStackView: UIStackView!
    @IBOutlet weak var photoPageControl: UIPageControl!
    @IBOutlet weak var firstImage: UIImageView!
    
//    let articlePhotos: [String] = ["https://firebasestorage.googleapis.com/v0/b/rosa-5438e.appspot.com/o/images%2Fkimaiku%2F2021-05-31%2010:27:51%20%2B0000.png?alt=media&token=ff1ee13b-8dc0-4c83-af76-3d08c1e6e06a", "https://firebasestorage.googleapis.com/v0/b/rosa-5438e.appspot.com/o/images%2Fkimaiku%2F2021-05-31%2010:27:51%20%2B0000.png?alt=media&token=ff1ee13b-8dc0-4c83-af76-3d08c1e6e06a"]
    
    override func awakeFromNib() {
        super.awakeFromNib()

        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
//        firstImage.kf.setImage(with: URL(string:articlePhotos[0]))
        
//        if articlePhotos.count > 1 {
//
//            for index in 1..<articlePhotos.count {
//                frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
//                frame.size = self.scrollView.frame.size
//                let imageView = UIImageView(frame: frame)
//                imageView.kf.setImage(with: URL(string:articlePhotos[index]))
//                self.photoStackView.addArrangedSubview(imageView)
//            }
//        } else {
//            photoPageControl.isHidden = true
//        }
        
//        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * CGFloat(articlePhotos.count),height: self.scrollView.frame.size.height)
        
    }
    
    func configureScrollView(article: Article) {
        let articlePhotos = article.photos
        firstImage.kf.setImage(with: URL(string:articlePhotos[0]))
        if articlePhotos.count > 1 {
        
            for index in 1..<articlePhotos.count {
                frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
                frame.size = self.scrollView.frame.size
                let imageView = UIImageView(frame: frame)
                imageView.kf.setImage(with: URL(string:articlePhotos[index]))
                self.photoStackView.addArrangedSubview(imageView)
            }
        } else {
            photoPageControl.isHidden = true
        }
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * CGFloat(articlePhotos.count),height: self.scrollView.frame.size.height)

    }
    
    func configurePageControl(article: Article) {
        // The total number of pages that are available is based on how many available photos we have.
        let articlePhotos = article.photos
        self.pageControl.numberOfPages = articlePhotos.count
        self.pageControl.currentPage = 0
    
    }

}

extension PhotoCell: UIScrollViewDelegate {

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        pageControl.currentPage = Int(page)
    }
}

// swiftlint:enable all
