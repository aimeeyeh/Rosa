//
//  EditNameTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/4.
//

import UIKit

class EditNameTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureName() {
        if let name = UserManager.shared.currentUser?.name {
            nameLabel.text = name
        }
    }

}
