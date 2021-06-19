//
//  CommentTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/19.
//

import UIKit
import Kingfisher

class CommentCell: UITableViewCell {
    @IBOutlet weak var authorPhoto: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var postedDateLabel: UILabel!
    @IBOutlet weak var postedContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCommentCell(comment: Comment) {
        authorPhoto.kf.setImage(with: URL(string: comment.authorPhoto))
        authorNameLabel.text = comment.authorName
        postedContentLabel.text = comment.content
        if let formattedDate = comment.date.formatToDateWithoutYearOnly() {
            postedDateLabel.text = formattedDate
        }
    }
    
}
