//
//  ArticleCollectionViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/20.
//

import UIKit
import Kingfisher

class ArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var articlePhoto: UIImageView!
    @IBOutlet weak var articleTitle: UILabel!
    
    override func awakeFromNib() {
      super.awakeFromNib()
        articlePhoto.layer.cornerRadius = articlePhoto.frame.height / 20
     }
    
    func configure(article: Article) {
        articlePhoto.kf.setImage(with: URL(string: article.photos[0]))
        articleTitle.text = article.title
    }
}
