//
//  CalenderViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit
import FSCalendar

class CalenderViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource,
                              UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var calenderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calnderView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var challenges: [Challenge] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var record: Record? {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()

    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: calnderView,
                                                action: #selector(calnderView.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()

    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        if UIDevice.current.model.hasPrefix("iPad") {
            calenderHeightConstraint.constant = 400
        }
        
        calnderView.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        
        // For UITest
        calnderView.accessibilityIdentifier = "calendar"
        
        fetchChallenge(date: Date())
        fetchRecord(date: Date())

    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchChallenge(date: Date())
        fetchRecord(date: Date())
    }
    
    func fetchRecord(date: Date) {
        RecordManager.shared.fetchRecord(date: date) { [weak self] result in
            
            switch result {
            
            case .success(let record):
                
                self?.record = record
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
    
    func fetchChallenge(date: Date) {
        ChallengeManager.shared.fetchChallenge(date: date) { [weak self] result in
            
            switch result {
            
            case .success(let challenges):
                
                self?.challenges = challenges
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
    
    deinit {
        print("\(#function)")
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch calnderView.scope {
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
        calenderHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(self.dateFormatter.string(from: date))")
//        var comp: DateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
//        comp.timeZone = TimeZone(abbreviation: "UTC")!
//        let adjustedDate = Calendar.current.date(from: comp)!
        fetchChallenge(date: date)
        fetchRecord(date: date)
        tableView.reloadData()
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if challenges.count != 0 {
            return challenges.count + 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: - 沒有challenge
        if challenges.count == 0 {
            switch indexPath.row {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarChallengeTableViewCell",
                                                            for: indexPath) as? CalendarChallengeTableViewCell {
                    cell.noChallengeConfigure()
                    return cell
                }
            default:
                if record == nil { // 沒有record
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarChallengeTableViewCell",
                                                                for: indexPath) as? CalendarChallengeTableViewCell {
                        cell.noRecordConfigure()
                        return cell
                    }
                } else { // 有record
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarRecordTableViewCell",
                                                                for: indexPath) as? CalendarRecordTableViewCell {
                        if let record = record {
                            cell.configure(record: record)
                        }
                        return cell
                    }
                }
            }
            // MARK: - 有challenge
        } else {
            switch indexPath.row {
            case 0..<challenges.count: // 前面幾個cell
                
//                if challenges.count != 0 {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarChallengeTableViewCell",
                                                                for: indexPath) as? CalendarChallengeTableViewCell {
                        cell.challengeImage.image = UIImage(named: challenges[indexPath.row].challengeImage)
                        cell.challengeTitle.text = challenges[indexPath.row].challengeTitle
                        cell.challengeTitle.textColor = .white
                        cell.challengeDesciption.text = "Skincare is Healthcare"
                        cell.challengeDesciption.textColor = .systemGray6
                        cell.challengeBackground.backgroundColor = UIColor.challengeColor(challenge: challenges[indexPath.row].challengeTitle)
                        cell.checkboxButton.setImage(UIImage(named: "unchecked"), for: .normal)
                        cell.checkboxButton.setImage(UIImage(named: "checked"), for: .selected)
                        cell.addShadow()
                        return cell
                    }
//                } else { //有record
//                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarRecordTableViewCell",
//                                                                for: indexPath) as? CalendarRecordTableViewCell {
//                        if let record = record {
//                            cell.configure(record: record)
//                        }
//                        return cell
//                    }
//                }
                
            default: // 最後一個cell
                
                if record == nil { // 沒record
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarChallengeTableViewCell",
                                                                for: indexPath) as? CalendarChallengeTableViewCell {
                        cell.noRecordConfigure()
                        return cell
                    }
                } else { // 有record
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarRecordTableViewCell",
                                                                for: indexPath) as? CalendarRecordTableViewCell {
                        if let record = record {
                            cell.configure(record: record)
                        }
                        return cell
                    }
                }
                
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if challenges.count != 0 {
            if record != nil {
                switch indexPath.row {
                case challenges.count:
                    return 900
                default:
                    return 90
                }
            } else {
                return 90
            }
        } else {
            if record != nil {
                switch indexPath.row {
                case 0:
                    return 90
                default:
                    return 900
                }
            } else {
                return 90
            }
        }
    }
}
