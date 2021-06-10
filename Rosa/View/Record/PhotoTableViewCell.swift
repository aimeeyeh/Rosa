//
//  PhotoTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/16.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var uploadFull: UIButton!
    @IBOutlet weak var uploadLeft: UIButton!
    @IBOutlet weak var uploadRight: UIButton!
    
    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    @IBOutlet weak var frontalLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    var onFullButtonPressed: (() -> Void)?
    var onLeftButtonPressed: (() -> Void)?
    var onRightButtonPressed: (() -> Void)?

    @IBAction func uploadFullPhoto(_ sender: UIButton) {
        onFullButtonPressed?()
    }
    @IBAction func uploadLeftPhoto(_ sender: UIButton) {
        onLeftButtonPressed?()
    }
    @IBAction func uploadRightPhoto(_ sender: UIButton) {
        onRightButtonPressed?()
    }
}
