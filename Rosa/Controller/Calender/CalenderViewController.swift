//
//  CalenderViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit
import FSCalendar
import SwiftEntryKit

class CalenderViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDataSource,
                              UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var calenderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calnderView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    var dateArray = [Date]()
    
    var allRecords: [Record] = [] {
        didSet {
            for record in allRecords {
                dateArray.append(record.date)
            }
            calnderView.reloadData()
        }
    }
    
    var challenges: [Challenge] = [] {
        didSet {
            tableView.reloadData()
            checkYesterdayProgress()
        }
    }

    var record: Record? {
        didSet {
            tableView.reloadData()
        }
    }
    
    // MARK: - Calendar Setup
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    
    fileprivate let gregorian: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)

    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: calnderView,
                                                action: #selector(calnderView.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
    }()
    
    // MARK: - viewDidLoad

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
        
        fetchAllRecords()
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchChallenge(date: Date())
        fetchRecord(date: Date())
        
    }
    
    // MARK: - Firebase Related Functions
    
    func fetchAllRecords() {
        RecordManager.shared.fetchAllRecords() { [weak self] result in
            
            switch result {
            
            case .success(let records):
                
                self?.allRecords = records
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
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
        fetchChallenge(date: date)
        fetchRecord(date: date)
        tableView.reloadData()
        
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let dateString = self.dateFormatter.string(from: date)
        var dateStringArray: [String] = []
        for date in dateArray {
            dateStringArray.append(self.dateFormatter.string(from: date))
        }
        if dateStringArray.contains(dateString) {
            return 1
        } else {
            return 0
        }
    }
    
    // MARK: - PopUp Message Setup
    
    func displaySuccessMessage() {
        let image = "success"
        let title = "Awesome!"
        let description =
        """
        You've completed the challenge.      \
        Keep on your good work, \
        and let your Skin be the first priority.
        
        """
        let button = "Got it!"
        SwiftEntryKit.display(entry: MyPopUpView(with: setupMessage(image: image,
                                                                    title: title,
                                                                    description: description,
                                                                    button: button)),
                              using: setupAttributes())
    }
    
    func displayFailureMessage() {
        let image = "fail"
        let title = "Oh No!"
        let description =
        """
        You've missed yesterday's challenge. \
        Add the challenge again \
        and Restart your 30 day challenge!
        
        """
        let button = "Try again"
        SwiftEntryKit.display(entry: MyPopUpView(with: setupMessage(image: image,
                                                                    title: title,
                                                                    description: description, button: button)),
                              using: setupAttributes())
    }
    
    func checkYesterdayProgress() {
        for challenge in challenges {
            if challenge.progress == 0 {
                print("\(challenge.challengeTitle) has failed")
                displayFailureMessage()
                ChallengeManager.shared.delete30dayChallenges(challengeTitle: challenge.challengeTitle)
            } else {
                return
            }
        }
    }
    
    func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        attributes.displayDuration = .infinity
        attributes.screenBackground = .color(color: .init(light: UIColor(white: 100.0/255.0, alpha: 0.3),
                                                          dark: UIColor(white: 50.0/255.0, alpha: 0.3)))
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 8
            )
        )
        
        attributes.entryBackground = .color(color: .standardBackground)
        attributes.roundCorners = .all(radius: 25)
        attributes.screenInteraction = .dismiss
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .enabled(
            swipeable: true,
            pullbackAnimation: .jolt
        )
        
        attributes.entranceAnimation = .init(
            translate: .init(
                duration: 0.7,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            scale: .init(
                from: 1.05,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            )
        )
        
        attributes.exitAnimation = .init(
            translate: .init(duration: 0.2)
        )
        attributes.popBehavior = .animated(
            animation: .init(
                translate: .init(duration: 0.2)
            )
        )
        
        attributes.positionConstraints.verticalOffset = 10
        attributes.statusBar = .dark
        return attributes
    }
    
    func setupMessage(image: String, title: String, description: String, button: String) -> EKPopUpMessage {
        
        let image = UIImage(named: image)!.withRenderingMode(.alwaysTemplate)
        let title = title
        let description = description
        
        let themeImage = EKPopUpMessage.ThemeImage(image: EKProperty.ImageContent(image: image,
                                                                                  size: CGSize(width: 60, height: 60),
                                                                                  tint: .black,
                                                                                  contentMode: .scaleAspectFit))
        
        let titleLabel = EKProperty.LabelContent(text: title, style: .init(font: UIFont.systemFont(ofSize: 24),
                                                                      color: .black,
                                                                      alignment: .center))
        
        let descriptionLabel = EKProperty.LabelContent(
            text: description,
            style: .init(
                font: UIFont.systemFont(ofSize: 16),
                color: .black,
                alignment: .center
            )
        )
        
        let button = EKProperty.ButtonContent(
            label: .init(
                text: button,
                style: .init(
                    font: UIFont.systemFont(ofSize: 16),
                    color: .black
                )
            ),
            backgroundColor: .init(UIColor.systemOrange),
            highlightedBackgroundColor: .clear
        )
        
        let message = EKPopUpMessage(themeImage: themeImage,
                                     title: titleLabel,
                                     description: descriptionLabel,
                                     button: button) {
            SwiftEntryKit.dismiss()
            self.fetchChallenge(date: Date())
        }
        return message
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
        // 沒有challenge
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
        // 有challenge
        } else {
            switch indexPath.row {
            case 0..<challenges.count: // 前面幾個cell
                    if let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarChallengeTableViewCell",
                                                                for: indexPath) as? CalendarChallengeTableViewCell {
                        cell.challengeConfigure(challenges: challenges, indexPath: indexPath)
                        cell.addShadow()
                        
                        var challenge = challenges[indexPath.row]
                        let progress = challenge.progress
                        let title = challenge.challengeTitle
                        
                        cell.onButtonPressed = {
                            
                            ChallengeManager.shared.updateChallengeProgress(challenge: &challenge,
                                                                            currentProgress: progress,
                                                                            currentChallengeTitle: title) {
                                [weak self] in self?.displaySuccessMessage()
                            }
                        
                        }
                        return cell
                    }
                
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
