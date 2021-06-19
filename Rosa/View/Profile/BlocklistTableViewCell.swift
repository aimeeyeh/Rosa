//
//  BlocklistTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/5.
//

import UIKit
import Kingfisher

class BlocklistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var unblockButton: UIButton!
    
    var onButtonPressed: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureBlocklist(blocklistUserData: User) {
        guard let photoURL = blocklistUserData.photo else { return }
        userImage.kf.setImage(with: URL(string: photoURL))
        userName.text = blocklistUserData.name
    }
    
    @IBAction func unblockUser(_ sender: Any) {
        onButtonPressed?()
    }
    
}
