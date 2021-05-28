//
//  TestViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/28.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var detailsLabel: UILabel!
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = user {
        detailsLabel.text = """
            ID: \(user.id)
            Name: \(String(describing: user.name))
            Email: \(String(describing: user.email))
            """
        }
    }

}
