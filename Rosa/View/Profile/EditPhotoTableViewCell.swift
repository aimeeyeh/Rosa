//
//  EditPhotoTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/4.
//

import UIKit

class EditPhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    var onButtonPressed: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        onButtonPressed?()
    }
    
}
