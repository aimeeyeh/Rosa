//
//  ContentTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/19.
//

import UIKit

class ContentCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createdTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
    }
    
    func configureContent(article: Article) {
        
        titleLabel.text = article.title
        contentLabel.text = article.content
        if let formattedDate = article.createdTime.formatToDateOnly() {
            createdTimeLabel.text = "Posted on ".localized() + String(formattedDate)
        }
    }
}
