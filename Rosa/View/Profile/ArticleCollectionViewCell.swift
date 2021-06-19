//
//  ArticleCollectionViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/20.
//

import UIKit
import Kingfisher

class ArticleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var articleImage: UIImageView!
    @IBOutlet weak var articleTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        articleImage.layer.cornerRadius = articleImage.frame.height / 20
    }
    
    func configureArticles(article: Article) {
        articleImage.kf.setImage(with: URL(string: article.photos[0]))
        articleTitleLabel.text = article.title
    }
}
