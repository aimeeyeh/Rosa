//
//  PostViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/20.
//

import UIKit

class PostViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func backToPreviousPage(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func postArticle(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
