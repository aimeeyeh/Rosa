//
//  PhotoTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/16.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var uploadFrontalBtn: UIButton!
    @IBOutlet weak var uploadLeftBtn: UIButton!
    @IBOutlet weak var uploadRightBtn: UIButton!
    @IBOutlet weak var frontalImage: UIImageView!
    @IBOutlet weak var leftImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    @IBOutlet weak var frontalLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    
    var onFullButtonPressed: (() -> Void)?
    
    var onLeftButtonPressed: (() -> Void)?
    
    var onRightButtonPressed: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
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
