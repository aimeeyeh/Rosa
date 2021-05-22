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
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

}
