//
//  RemarkTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/16.
//

import UIKit

class RemarkTableViewCell: UITableViewCell {

    @IBOutlet weak var remarkTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
