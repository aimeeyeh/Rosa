//
//  RecordDetailViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit
import FSCalendar

class RecordDetailViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calenderHeightConstraint: NSLayoutConstraint!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: calenderView,
                                                action: #selector(calenderView.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()

    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calenderHeightConstraint.constant = 400
        }
        
        calenderView.select(Date())
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.view.layoutIfNeeded()
        self.calenderView.scope = .week
        
        // For UITest
        calenderView.accessibilityIdentifier = "calendar"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    deinit {
        print("\(#function)")
    }

    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calenderView.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calenderHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
}

extension RecordDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
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
        case 6:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RemarkTableViewCell",
                                                            for: indexPath) as? RemarkTableViewCell {
                return cell
            }
            
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonsTableViewCell",
                                                            for: indexPath) as? ButtonsTableViewCell {
                cell.onButtonPressed = { [unowned self] in
                    // Do what you need to, no need to capture self however, if you won't access it.
                    self.navigationController?.popViewController(animated: true)
                    self.tabBarController?.tabBar.isHidden = false
                }
                return cell
            }
           
        }
        return UITableViewCell()
    }

}

extension RecordDetailViewController: FSCalendarDataSource, FSCalendarDelegate {
    
}
