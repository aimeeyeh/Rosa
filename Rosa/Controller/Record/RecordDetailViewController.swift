//
//  RecordDetailViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit

class RecordDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true

    }

}

extension RecordDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell",
                                                            for: indexPath) as? WeatherTableViewCell {
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RoutineTableViewCell",
                                                            for: indexPath) as? RoutineTableViewCell {
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoTableViewCell",
                                                            for: indexPath) as? PhotoTableViewCell {
                return cell
            }
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "StatusTableViewCell",
                                                            for: indexPath) as? StatusTableViewCell {
                return cell
            }
        case 4:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell",
                                                            for: indexPath) as? MealTableViewCell {
                return cell
            }
        case 5:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell",
                                                            for: indexPath) as? ActivityTableViewCell {
                return cell
            }
            
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RemarkTableViewCell",
                                                            for: indexPath) as? RemarkTableViewCell {
                return cell
            }
           
        }
        return UITableViewCell()
    }

}
