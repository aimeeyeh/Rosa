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
    @IBOutlet weak var arthorName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likedAmount: UILabel!
    @IBOutlet weak var articlePhoto: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!

    override func awakeFromNib() {
      super.awakeFromNib()
        arthorPhoto.layer.cornerRadius = arthorPhoto.frame.height / 2
        articlePhoto.layer.cornerRadius = articlePhoto.frame.height / 20
     }
    
    func configureArticleCell(article: Article) {
        arthorName.text = article.author
        likedAmount.text = "\(article.likes)"
        articleTitle.text = article.title
        articlePhoto.kf.setImage(with: URL(string: article.photos[0]))
    }
    
    @IBAction func likedArticle(_ sender: Any) {
        likeButton.isSelected = !likeButton.isSelected
    }
}
