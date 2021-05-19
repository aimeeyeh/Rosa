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
        "熱門",
        "保養",
        "戒斷",
        "防曬"
    ]
    
    func setTitle(index: Int) {
      filterLabel.text = itemArray[index]
    }

}
