//
//  RecordViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit

class RecordViewController: UIViewController {

    @IBOutlet weak var challengeButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var challengeBackgroundView: UIView!
    @IBOutlet weak var recordBackgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        configure()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func configure() {
        challengeBackgroundView.backgroundColor = UIColor(red: 1.00, green: 0.84, blue: 0.64, alpha: 1.00)
        recordBackgroundView.backgroundColor = UIColor(red: 1.00, green: 0.84, blue: 0.64, alpha: 1.00)
        challengeBackgroundView.layer.cornerRadius = 20
        recordBackgroundView.layer.cornerRadius = 20
    }

}
