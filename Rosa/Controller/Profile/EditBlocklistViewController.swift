//
//  EditBlocklistViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/4.
//

import UIKit

class EditBlocklistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noBlockedUserLabel: UILabel!
    
    var blocklist: [String] = [] {
        didSet {
            if !blocklist.isEmpty {
                tableView.isHidden = false
                noBlockedUserLabel.isHidden = true
                fetchBlocklistUserData()
            } else {
                noBlockedUserLabel.isHidden = false
                tableView.isHidden = true
            }
            
        }
    }
    
    var blocklistUserData: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        getUserBlocklist()
    }
    
    func getUserBlocklist() {
        
        UserManager.shared.fetchUser { result in
            
            switch result {
            
            case .success(let user):
                
                guard let blocklist = user.blocklist else { return }
                self.blocklist = blocklist
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
        
    }
    
    func fetchBlocklistUserData() {
        UserManager.shared.fetchBlocklistUserData(blocklist: self.blocklist) { [weak self] result in
            
            switch result {
            
            case .success(let users):
                
                self?.blocklistUserData = users
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
}

extension EditBlocklistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return blocklistUserData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "BlocklistTableViewCell", for: indexPath) as? BlocklistTableViewCell {
            cell.configureBlocklist(blocklistUserData: blocklistUserData[indexPath.row])
            cell.onButtonPressed = {
                UserManager.shared.removeFromBlocklist(blocklistUserID: self.blocklistUserData[indexPath.row].id)
                self.getUserBlocklist()
            }
            return cell
        }
        return UITableViewCell()
    }
    
}
