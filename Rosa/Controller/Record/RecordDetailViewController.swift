//
//  RecordDetailViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit
import FSCalendar
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

// swiftlint:disable all

class RecordDetailViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calenderHeightConstraint: NSLayoutConstraint!
    
    var weather: String = "" 
    var feeling: String = ""
    var glassAmount: Int = 0
    var sleepAmount: Double = 0
    var remark: String = ""
    var mealDairyFree: Bool = false
    var mealGlutenFree: Bool = false
    var mealJunkFree: Bool = false
    var mealSugarFree: Bool = false
    var outdoor: Bool = false
    var makeup: Bool = false
    var menstrual: Bool = false
    var selectedDate: Date = Date()
    
    

    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = TimeZone.current
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
            @unknown default:
                fatalError()
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
        self.selectedDate = date
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showWaterPage" {

            if let waterVC = segue.destination as? WaterViewController {
                
                waterVC.touchHandler = { [weak self] glassAmount in
                    
                    self?.glassAmount = glassAmount
                }
            }
        } else if segue.identifier == "showSleepPage" {
            if let sleepVC = segue.destination as? SleepViewController {
                
                sleepVC.touchHandler = { [weak self] sleepAmount in
    
                    self?.sleepAmount = sleepAmount
                }
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell",
                                                           for: indexPath) as? WeatherTableViewCell else { return UITableViewCell()}
            
            cell.touchHandler = { [weak self] selectedWeather in
                
                self?.weather = selectedWeather
            }
            
            return cell
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
                cell.touchHandler = { [weak self] selectedFeeling in
                    
                    self?.feeling = selectedFeeling
                }
                return cell
            }
        case 4:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MealTableViewCell",
                                                            for: indexPath) as? MealTableViewCell {
                cell.touchHandler = { [weak self] mealStatus in
                    
                    self?.mealDairyFree = mealStatus[0]
                    self?.mealGlutenFree = mealStatus[1]
                    self?.mealJunkFree = mealStatus[2]
                    self?.mealSugarFree = mealStatus[3]
                }
                return cell
            }
        case 5:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell",
                                                            for: indexPath) as? ActivityTableViewCell {
                cell.touchHandler = { [weak self] activityStatus in
                    
                    self?.outdoor = activityStatus[0]
                    self?.makeup = activityStatus[1]
                    self?.menstrual = activityStatus[2]
                }
                
                return cell
            }
        case 6:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "RemarkTableViewCell",
                                                            for: indexPath) as? RemarkTableViewCell {
                cell.touchHandler = { [weak self] remark in
                    
                    self?.remark = remark
                }
                return cell
            }
            
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonsTableViewCell",
                                                            for: indexPath) as? ButtonsTableViewCell {
                
                cell.onButtonPressed = { [unowned self] in
                    // Do what you need to, no need to capture self however, if you won't access it.
                    self.navigationController?.popViewController(animated: true)
                    self.tabBarController?.tabBar.isHidden = false
                    var record = Record(id: "default", date: selectedDate, weather: weather,
                                        photos: ["photo1", "photo2", "photo3"], feeling: feeling, water: glassAmount,
                                                sleep: sleepAmount, mealDairyFree: mealDairyFree, mealGlutenFree: mealGlutenFree,
                                                mealJunkFree: mealJunkFree, mealSugarFree: mealSugarFree, outdoor: outdoor,
                                                makeup: makeup, menstrual: menstrual, remark: remark)
                    
                    RecordManager.shared.postDailyRecord(record: &record) { result in
                        
                        switch result {
                        
                        case .success:
                            
                            print("onTapUploadRecord, success")
                            
                        case .failure(let error):
                            
                            print("onTapUploadRecord, failure: \(error)")
                        }
                    }
                }
                
                cell.cancelButtonPressed = { [unowned self] in
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

// swiftlint:enable all
