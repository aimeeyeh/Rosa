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
    
//    let itemArray = [
//        "酒糟",
//        "保養",
//        "戒斷",
//        "防曬",
//        "醫美"
//    ]
    
    let itemArray = [
        "Rosacea",
        "Skincare",
        "Diet",
        "Sunscreen",
        "Cosmetics"
    ]
    
    func setTitle(index: Int) {
      filterLabel.text = itemArray[index]
    }

}
