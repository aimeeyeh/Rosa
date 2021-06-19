//
//  CalenderViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit
import FSCalendar
import SwiftEntryKit
import Kingfisher
import SnapKit
import LiquidFloatingActionButton

class CalenderViewController: UIViewController, UIGestureRecognizerDelegate, FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var calenderHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var calnderView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    
    let blackView = UIView(frame: UIScreen.main.bounds)
    
    var cells: [LiquidFloatingCell] = []
    
    var floatingActionButton: LiquidFloatingActionButton!
    
    var dateArray: [Date] = [] {
        didSet {
            calnderView.reloadData()
        }
    }
    
    var allRecords: [Record] = [] {
        didSet {
            dateArray = []
            for record in allRecords {
                dateArray.append(record.date)
            }
            calnderView.reloadData()
        }
    }
    
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
        floatingButtonSetup()
        self.navigationController?.isNavigationBarHidden = true
        
        if UIDevice.current.model.hasPrefix("iPad") {
            calenderHeightConstraint.constant = 400
        }
        // For UITest
        calnderView.accessibilityIdentifier = "calendar"
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
        tableView.addGestureRecognizer(longPress)
    }
    
    // MARK: - viewWillAppear
    
    override func viewWillAppear(_ animated: Bool) {
        fetchAllRecords()
        calnderView.select(Date())
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        fetchChallenge(date: Date())
        fetchRecord(date: Date())
    }
    
    // MARK: - Long Press Gesture
    
    @objc func longPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            guard let indexPath = tableView.indexPathForRow(at: touchPoint) else { return }
            if challenges.isEmpty && record != nil {
                if indexPath.row == 1 {
                    showActoinSheet()
                }
            } else if !challenges.isEmpty && record != nil {
                if indexPath.row == challenges.count {
                    showActoinSheet()
                }
            }
        }
    }
    
    func showActoinSheet() {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel".localized(), style: .cancel) {_ in print("cancel")}
        actionSheetController.addAction(cancelActionButton)
        let deleteActionButton = UIAlertAction(title: "Delete".localized(), style: .destructive) {_ in
            print("deleted")
            if let recordID = self.record?.id {
                RecordManager.shared.deleteRecord(recordID: recordID)
                self.record = nil
                self.tableView.reloadData()
            }
            self.fetchAllRecords()
        }
        actionSheetController.addAction(deleteActionButton)
        actionSheetController.view.tintColor = .darkGray
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: - Firebase Related Functions
    
    func fetchAllRecords() {
        RecordManager.shared.fetchAllRecords { [weak self] result in
            
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
                
                if date.formatToDateOnly() == Date().formatToDateOnly() {
                    self?.checkYesterdayProgress(challenges: challenges)
                }
                
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
        let title = "Awesome!".localized()
        let description = "You've completed the challenge.".localized() +
            " Keep on your good work, and let your Skin be the first priority.".localized()
        let button = "Got it!".localized()
        SwiftEntryKit.display(
            entry: MyPopUpView(
                with: setupMessage(image: image, title: title, description: description, button: button)),
            using: PopUpMessage.shared.setupAttributes()
        )
    }
    
    func displayFailureMessage() {
        let image = "fail"
        let title = "Oh No!".localized()
        let description = "You've missed yesterday's challenge.".localized() +
            " Add the challenge again and Restart your 30 day challenge!".localized()
        let button = "Try again".localized()
        SwiftEntryKit.display(
            entry: MyPopUpView(
                with: setupMessage(image: image, title: title, description: description, button: button)),
            using: PopUpMessage.shared.setupAttributes()
        )
    }
    
    func checkYesterdayProgress(challenges: [Challenge]) {
        let filteredChallenges = challenges.filter { $0.progress == 0 && $0.isFirstDay == false }
        if !filteredChallenges.isEmpty {
            let dispatchGroup = DispatchGroup()
            for challenge in filteredChallenges {
                dispatchGroup.enter()
                ChallengeManager.shared.delete30dayChallenges(
                    challengeTitle: challenge.challengeTitle) { _ in
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
                self.displayFailureMessage()
            }
        }
    }
    
    func setupMessage(image: String, title: String, description: String, button: String) -> EKPopUpMessage {
        let image = UIImage(named: image)!.withRenderingMode(.alwaysTemplate)
        let title = title
        let description = description
        let themeImage = EKPopUpMessage.ThemeImage(
            image: EKProperty.ImageContent(
                image: image, size: CGSize(width: 60, height: 60), tint: .black, contentMode: .scaleAspectFit)
        )
        let titleLabel = EKProperty.LabelContent(
            text: title, style: .init(
                font: UIFont.systemFont(ofSize: 24), color: .black, alignment: .center)
        )
        let descriptionLabel = EKProperty.LabelContent(
            text: description, style: .init(font: UIFont.systemFont(ofSize: 16), color: .black, alignment: .center)
        )
        let button = EKProperty.ButtonContent(
            label: .init(text: button, style: .init(font: UIFont.systemFont(ofSize: 16), color: .black)),
            backgroundColor: .init(UIColor.systemOrange), highlightedBackgroundColor: .clear
        )
        let message = EKPopUpMessage(
            themeImage: themeImage, title: titleLabel, description: descriptionLabel, button: button) {
            SwiftEntryKit.dismiss()
            self.fetchChallenge(date: Date())
        }
        return message
    }
    
}

// MARK: - UITableViewDataSource

extension CalenderViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !challenges.isEmpty {
            return challenges.count + 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if challenges.isEmpty {
            switch indexPath.row {
            case 0:
                return dequeueNoChallengeCell(indexPath: indexPath)
            default:
                if record == nil {
                    return dequeueNoRecordCell(indexPath: indexPath)
                } else {
                    return dequeueRecordCell(indexPath: indexPath)
                }
            }
        } else {
            switch indexPath.row {
            case 0..<challenges.count:
                return dequeueChallengeCell(indexPath: indexPath)
            default:
                if record == nil {
                    return dequeueNoRecordCell(indexPath: indexPath)
                } else {
                    return dequeueRecordCell(indexPath: indexPath)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !challenges.isEmpty {
            if record != nil {
                if indexPath.row == challenges.count {
                    return 900
                }
            }
        } else {
            if record != nil {
                if indexPath.row == 0 {
                    return 90
                } else {
                    return 900
                }
            }
        }
        return 90
    }
    
    // MARK: - dequeue different TableViewCells
    
    func dequeueNoRecordCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "CalendarChallengeTableViewCell", for: indexPath) as? CalendarChallengeTableViewCell {
            cell.noRecordConfigure()
            return cell
        }
        return UITableViewCell()
    }
    
    func dequeueNoChallengeCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "CalendarChallengeTableViewCell",
                for: indexPath) as? CalendarChallengeTableViewCell else {
            return UITableViewCell()
        }
        cell.noChallengeConfigure()
        return cell
    }
    
    func dequeueRecordCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
                withIdentifier: "CalendarRecordTableViewCell", for: indexPath) as? CalendarRecordTableViewCell,
              let record = record else { return UITableViewCell() }
        cell.configure(record: record)
        return cell
    }
    
    func dequeueChallengeCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "CalendarChallengeTableViewCell", for: indexPath) as? CalendarChallengeTableViewCell {
            cell.challengeConfigure(challenges: challenges, indexPath: indexPath)
            cell.addShadow()
            var challenge = challenges[indexPath.row]
            cell.onButtonPressed = {
                ChallengeManager.shared.updateChallengeProgress(
                    challenge: &challenge, currentProgress: challenge.progress,
                    currentChallengeTitle: challenge.challengeTitle) {
                    [weak self] in self?.displaySuccessMessage()
                    challenge.isChecked = true
                }
            }
            return cell
        }
        return UITableViewCell()
    }
    
}

// MARK: - Floating Button

extension CalenderViewController: LiquidFloatingActionButtonDataSource,
                                  LiquidFloatingActionButtonDelegate,
                                  RecordConfirmedDelegate {
    
    func onConfirmBtnPressed() {
        dismiss(animated: true, completion: {
            self.fetchChallenge(date: Date())
            self.fetchRecord(date: Date())
        })
    }
    
    func floatingButtonSetup() {
        let createButton: (CGRect, LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton
            = { (frame, style) in
                let floatingActionButton = CustomDrawingActionButton(frame: frame)
                floatingActionButton.animateStyle = style
                floatingActionButton.dataSource = self
                floatingActionButton.delegate = self
                return floatingActionButton
            }
        
        let customCellFactory: (String) -> LiquidFloatingCell = { (iconName) in
            let cell = CustomCell(icon: UIImage(named: iconName)!, name: iconName.localized())
            return cell
        }
        cells.append(customCellFactory("Record"))
        cells.append(customCellFactory("Challenge"))
        
        let floatingFrame = CGRect(
            x: self.view.frame.width - 72, y: self.view.frame.height - 155, width: 56, height: 56
        )
        let bottomRightButton = createButton(floatingFrame, .up)
        bottomRightButton.image = UIImage(named: "plus")
        bottomRightButton.color = UIColor.rgb(red: 255, green: 153, blue: 94, alpha: 1)
        self.view.addSubview(bottomRightButton)
    }
    
    func numberOfCells(_ liquidFloatingActionButton: LiquidFloatingActionButton) -> Int {
        return cells.count
    }
    
    func cellForIndex(_ index: Int) -> LiquidFloatingCell {
        return cells[index]
    }
    
    func liquidFloatingActionButton(_ liquidFloatingActionButton: LiquidFloatingActionButton,
                                    didSelectItemAtIndex index: Int) {
        if index == 0 {
            if let recordDetailVC = UIStoryboard.record.instantiateViewController(
                withIdentifier: "RecordDetailViewController") as? RecordDetailViewController {
                self.navigationController?.pushViewController(recordDetailVC, animated: true)
            }
        } else {
            if let challengeVC = UIStoryboard.challenge.instantiateViewController(
                withIdentifier: "ChallengeViewController") as? ChallengeViewController {
                challengeVC.delegate = self
                present(challengeVC, animated: true, completion: nil)
            }
        }
        liquidFloatingActionButton.close()
    }
    
    func liquidFloatingActionButtonWillOpenDrawer(_ liquidFloatingActionButton: LiquidFloatingActionButton) {
        blackView.backgroundColor = .black
        blackView.alpha = 0
        blackView.tag = 100
        self.view.insertSubview(blackView, at: 2)
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0) {
            self.blackView.alpha = 0.5
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func liquidFloatingActionButtonWillCloseDrawer(_ liquidFloatingActionButton: LiquidFloatingActionButton) {
        blackView.removeFromSuperview()
        self.tabBarController?.tabBar.isHidden = false
    }
}
