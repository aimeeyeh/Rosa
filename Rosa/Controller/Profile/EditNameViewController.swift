//
//  EditNameViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/4.
//

import UIKit
import IQKeyboardManagerSwift

class EditNameViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.borderStyle = .roundedRect
        textField.tintColor = .lightGray
        configurePlaceholder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func configurePlaceholder() {
        guard let name = UserManager.shared.currentUser?.name else { return }
        textField.attributedPlaceholder = NSAttributedString(string: name)
    }
    
    @IBAction func editName(_ sender: Any) {
        if let name = textField.text {
            UserManager.shared.updateUserName(name: name)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
