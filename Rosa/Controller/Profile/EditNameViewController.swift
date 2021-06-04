//
//  EditNameViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/4.
//

import UIKit

class EditNameViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        textField.borderStyle = .roundedRect
        textField.tintColor = .lightGray
        
    }
}
