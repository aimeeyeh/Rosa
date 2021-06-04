//
//  PrivacyViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/4.
//

import UIKit

class PrivacyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}

extension PrivacyViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyTableViewCell",
                                                    for: indexPath) as? PrivacyTableViewCell {
            return cell
        }
        return UITableViewCell()
    }
    
}
