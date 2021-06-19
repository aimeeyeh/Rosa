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
    
    func configureName() {
        if let name = UserManager.shared.currentUser?.name {
            nameLabel.text = name
        }
    }
    
}
