//
//  ArticleCollectionViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/20.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var articlePhoto: UIImageView!
    
    override func awakeFromNib() {
      super.awakeFromNib()
        articlePhoto.layer.cornerRadius = articlePhoto.frame.height / 20
     }
}
