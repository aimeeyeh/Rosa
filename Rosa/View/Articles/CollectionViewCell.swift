//
//  CollectionViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/13.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var arthorPhoto: UIImageView!
    @IBOutlet weak var arthorNameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likedAmountLabel: UILabel!
    @IBOutlet weak var articlePhoto: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        arthorPhoto.layer.cornerRadius = arthorPhoto.frame.height / 2
        articlePhoto.layer.cornerRadius = articlePhoto.frame.height / 20
    }
    
    func configureArticleCell(article: Article) {
        arthorPhoto.kf.setImage(with: URL(string: article.authorPhoto))
        arthorNameLabel.text = article.authorName
        likedAmountLabel.text = "\(article.likes)"
        articleTitleLabel.text = article.title
        if !article.photos.isEmpty {
            articlePhoto.kf.setImage(with: URL(string: article.photos[0]))
        }
    }
    
    @IBAction func likedArticle(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
    }
}
