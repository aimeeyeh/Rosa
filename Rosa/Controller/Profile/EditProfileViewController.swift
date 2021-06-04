//
//  EditProfileViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/4.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditPhotoTableViewCell",
                                                        for: indexPath) as? EditPhotoTableViewCell {
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditNameTableViewCell",
                                                        for: indexPath) as? EditNameTableViewCell {
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditBlocklistTableViewCell",
                                                        for: indexPath) as? EditBlocklistTableViewCell {
                return cell
            }
        }
                            
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 180
        default:
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            return
        case 1:
            performSegue(withIdentifier: "showEditNameVC", sender: self)
        default:
            performSegue(withIdentifier: "showEditBlocklistVC", sender: self)
        }
    }
    
}
