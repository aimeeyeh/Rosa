//
//  HeaderCollectionReusableView.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/14.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {

    static let identifer = "HeaderCollectionReusableView"

    private let greetingsLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private let pastSevenDaysLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    func configureLabels() {
        greetingsLabel.text = "你好，Aimee"
        greetingsLabel.textColor = .black
        greetingsLabel.font = UIFont.systemFont(ofSize: 30.0)
        greetingsLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(greetingsLabel)
        NSLayoutConstraint.activate([
            greetingsLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            greetingsLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15)
        ])

        pastSevenDaysLabel.text = "過去七天"
        pastSevenDaysLabel.textColor = .lightGray
        pastSevenDaysLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        pastSevenDaysLabel.translatesAutoresizingMaskIntoConstraints = false

        addSubview(pastSevenDaysLabel)

        NSLayoutConstraint.activate([
            pastSevenDaysLabel.topAnchor.constraint(equalTo: greetingsLabel.bottomAnchor, constant: 15),
            pastSevenDaysLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20)
        ])

    }

}
