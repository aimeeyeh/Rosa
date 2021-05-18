//
//  HomeCollectionViewCell.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/13.
//

import UIKit
import MKRingProgressView

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardView: UIView!

    let ringProgressView = RingProgressView()
    
    func addRingProgressView() {

        ringProgressView.startColor = UIColor(red: 1.00, green: 0.84, blue: 0.64, alpha: 1.00)
        ringProgressView.endColor = .orange
        ringProgressView.backgroundRingColor = UIColor(red: 1.00, green: 0.84, blue: 0.64, alpha: 0.5)
        ringProgressView.ringWidth = 14
        ringProgressView.hidesRingForZeroProgress = true
        ringProgressView.progress = 0.4
        ringProgressView.gradientImageScale = 0.5
        ringProgressView.shadowOpacity = 0.0
        ringProgressView.allowsAntialiasing = false
        ringProgressView.style = .square
        ringProgressView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(ringProgressView)
        
        NSLayoutConstraint.activate([

            ringProgressView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30),
            ringProgressView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            ringProgressView.heightAnchor.constraint(equalToConstant: 100),
            ringProgressView.widthAnchor.constraint(equalToConstant: 100)
            
        ])
    }
    
    let cellLabel = UILabel()
    let percentageLabel = UILabel()
    
    func addLabel() {
        cellLabel.text = "挑戰進度"
        cellLabel.textColor = .black
        cellLabel.font = UIFont.boldSystemFont(ofSize: 15)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(cellLabel)
        
        NSLayoutConstraint.activate([
            cellLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30),
            cellLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30)
        ])

        percentageLabel.text = "40%"
        percentageLabel.textColor = .black
        percentageLabel.font = UIFont.systemFont(ofSize: 15.0)
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(percentageLabel)
        
        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: ringProgressView.centerYAnchor)
        ])
    }
}
