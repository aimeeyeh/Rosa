//
//  ProfileViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var cardView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardView.backgroundColor = .white

        cardView.layer.cornerRadius = 10.0

        cardView.layer.shadowColor = UIColor.gray.cgColor

        cardView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)

        cardView.layer.shadowRadius = 6.0

        cardView.layer.shadowOpacity = 0.7
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
