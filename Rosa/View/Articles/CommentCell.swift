//
//  CommentTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/19.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var authorPhoto: UIImageView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var postedDate: UILabel!
    @IBOutlet weak var postedContent: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCommentCell(comment: Comment) {
        authorName.text = comment.author
        postedContent.text = comment.content
        if let formattedDate = comment.date.formatToDateWithoutYearOnly() {
            postedDate.text = formattedDate
        }
    }

}
