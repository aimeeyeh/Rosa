//
//  FilterTableViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/19.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    let itemArray = [
        "Rosacea".localized(),
        "Skincare".localized(),
        "Diet".localized(),
        "Sun Protection".localized(),
        "Cosmetics".localized()
    ]
    
    func setTitle(index: Int) {
        filterLabel.text = itemArray[index]
    }
    
}
