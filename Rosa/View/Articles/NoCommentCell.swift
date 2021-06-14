//
//  NoCommentCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/1.
//

import UIKit

class NoCommentCell: UITableViewCell {

    @IBOutlet weak var noCommentsLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        noCommentsLabel.text = "No comments yet".localized()
    }

}
