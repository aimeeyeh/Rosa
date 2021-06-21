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
import FirebaseStorage
import Kingfisher
import Lottie
import IQKeyboardManagerSwift

enum PhotoType {
    case fullPhoto
    case leftPhoto
    case rightPhoto
}

class RecordDetailViewController: UIViewController, UIGestureRecognizerDelegate,
                                  FSCalendarDataSource, FSCalendarDelegate {
    
    @IBOutlet weak var lottieView: AnimationView!
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calenderHeightConstraint: NSLayoutConstraint!
    
    private let storage = Storage.storage().reference()
    
    var waterButtonState: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
    var sleepButtonState: Bool = false {
        didSet {
            tableView.reloadData()
        }
    }
    
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
    
    var currentPhotoType: PhotoType?
    
    var fullPhotoUrl: String = ""
    
    var leftPhotoUrl: String = ""
    
    var rightPhotoUrl: String = ""
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(
            target: calenderView, action: #selector(calenderView.handleScopeGesture(_:))
        )
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

    }
    
    override func viewWillAppear(_ animated: Bool) {
        lottieView.isHidden = true
        showLoadingView()
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func showLoadingView() {
        let animationView = Animation.named("bouncingBall")
        lottieView.animation = animationView
        lottieView.animationSpeed = 0.8
        lottieView.play()
        lottieView.loopMode = .loop
    }
    
    // MARK: - Calendar UIGestureRecognizerDelegate
    
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

extension RecordDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func setPhotoUrl(url: String) {
        switch currentPhotoType {
        case .fullPhoto:
            fullPhotoUrl = url
        case .leftPhoto:
            leftPhotoUrl = url
        default:
            rightPhotoUrl = url
        }
        tableView.reloadData()
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        lottieView.isHidden = false
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
              let imageData = image.pngData(),
              let userID = UserManager.shared.currentUser?.id else { return }
        
        let imageName = "images/\(userID)/\(Date()).png"
        
        let ref = storage.child(imageName)
        
        ref.putData(imageData, metadata: nil) { [weak self] _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            self?.storage.child(imageName).downloadURL { [weak self] url, error in
                guard let url = url, error == nil else { return }
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                self?.lottieView.isHidden = true
                self?.setPhotoUrl(url: urlString)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWaterPage" {
            
            guard let waterVC = segue.destination as? WaterViewController else { return }
            
            waterVC.touchHandler = { [weak self] glassAmount in
                self?.glassAmount = glassAmount
            }
            
            waterVC.onConfirmButtonPressed = {
                self.waterButtonState = true
            }
            
            waterVC.onCancelButtonPressed = {
                self.waterButtonState = false
            }
            
        } else if segue.identifier == "showSleepPage" {
            
            guard let sleepVC = segue.destination as? SleepViewController else { return }
            
            sleepVC.touchHandler = { [weak self] sleepAmount in
                self?.sleepAmount = sleepAmount
            }
            
            sleepVC.onSleepConfirmButtonPressed = {
                self.sleepButtonState = true
            }
            
            sleepVC.onSleepCancelButtonPressed = {
                self.sleepButtonState = false
            }
        }
    }
    
}

extension RecordDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        
        case 0:
            return dequeueWeatherCell(indexPath: indexPath)
            
        case 1:
            return dequeueRoutineCell(indexPath: indexPath)
            
        case 2:
            return dequeuePhotoCell(indexPath: indexPath)
            
        case 3:
            return dequeueStatusCell(indexPath: indexPath)
            
        case 4:
            return dequeueMealCell(indexPath: indexPath)
            
        case 5:
            return dequeueActivityCell(indexPath: indexPath)
            
        case 6:
            return dequeueRemarkCell(indexPath: indexPath)
            
        default:
            return dequeueButtonsCell(indexPath: indexPath)
        }
    }
    
    // MARK: - dequeue UITableViewCells
    
    func dequeueWeatherCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "WeatherTableViewCell", for: indexPath) as? WeatherTableViewCell {
            
            cell.touchHandler = { [weak self] selectedWeather in
                self?.weather = selectedWeather
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func dequeueRoutineCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "RoutineTableViewCell", for: indexPath) as? RoutineTableViewCell {
            
            cell.waterButton.isSelected = self.waterButtonState
            cell.waterButton.checkButtonState()
            cell.sleepButton.isSelected = self.sleepButtonState
            cell.sleepButton.checkButtonState()
            return cell
        }
        return UITableViewCell()
    }
    
    func dequeuePhotoCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "PhotoTableViewCell", for: indexPath) as? PhotoTableViewCell {
            
            func showPicker(_ photoType: PhotoType) {
                self.currentPhotoType = photoType
                let picker = UIImagePickerController()
                picker.sourceType = .photoLibrary
                picker.delegate = self
                picker.allowsEditing = true
                self.present(picker, animated: true)
            }
            
            cell.onFullButtonPressed = {
                showPicker(PhotoType.fullPhoto)
            }
            
            cell.onLeftButtonPressed = {
                showPicker(PhotoType.leftPhoto)
            }
            
            cell.onRightButtonPressed = {
                showPicker(PhotoType.rightPhoto)
            }
            
            if fullPhotoUrl.isEmpty {
                cell.uploadFrontalBtn.tintColor = .lightGray
                cell.frontalLabel.isHidden = false
            } else {
                cell.frontalLabel.isHidden = true
                cell.uploadFrontalBtn.tintColor = .clear
                cell.frontalImage.kf.setImage(with: URL(string: fullPhotoUrl))
            }
            
            if leftPhotoUrl.isEmpty {
                cell.leftLabel.isHidden = false
                cell.uploadLeftBtn.tintColor = .lightGray
            } else {
                cell.leftLabel.isHidden = true
                cell.uploadLeftBtn.tintColor = .clear
                cell.leftImage.kf.setImage(with: URL(string: leftPhotoUrl))
            }
            
            if rightPhotoUrl.isEmpty {
                cell.rightLabel.isHidden = false
                cell.uploadRightBtn.tintColor = .lightGray
            } else {
                cell.rightLabel.isHidden = true
                cell.uploadRightBtn.tintColor = .clear
                cell.rightImage.kf.setImage(with: URL(string: rightPhotoUrl))
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func dequeueStatusCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "StatusTableViewCell", for: indexPath) as? StatusTableViewCell {
            
            cell.touchHandler = { [weak self] selectedFeeling in
                
                self?.feeling = selectedFeeling
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func dequeueMealCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "MealTableViewCell", for: indexPath) as? MealTableViewCell {
            
            cell.touchHandler = { [weak self] mealStatus in
                self?.mealDairyFree = mealStatus[0]
                self?.mealGlutenFree = mealStatus[1]
                self?.mealJunkFree = mealStatus[2]
                self?.mealSugarFree = mealStatus[3]
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func dequeueActivityCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityTableViewCell",
                                                    for: indexPath) as? ActivityTableViewCell {
            
            cell.touchHandler = { [weak self] activityStatus in
                self?.outdoor = activityStatus[0]
                self?.makeup = activityStatus[1]
                self?.menstrual = activityStatus[2]
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func dequeueRemarkCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "RemarkTableViewCell", for: indexPath) as? RemarkTableViewCell {
            
            cell.touchHandler = { [weak self] remark in
                self?.remark = remark
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func dequeueButtonsCell(indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(
            withIdentifier: "ButtonsTableViewCell", for: indexPath) as? ButtonsTableViewCell {
            
            cell.onConfirmButtonPressed = { [unowned self] in
                self.navigationController?.popViewController(animated: true)
                self.tabBarController?.tabBar.isHidden = false
                var record = Record(id: "default", date: selectedDate, weather: weather, fullPhoto: fullPhotoUrl,
                                    leftPhoto: leftPhotoUrl, rightPhoto: rightPhotoUrl, feeling: feeling,
                                    water: glassAmount, sleep: sleepAmount, mealDairyFree: mealDairyFree,
                                    mealGlutenFree: mealGlutenFree, mealJunkFree: mealJunkFree,
                                    mealSugarFree: mealSugarFree, outdoor: outdoor, makeup: makeup,
                                    menstrual: menstrual, remark: remark)
                
                RecordManager.shared.postDailyRecord(record: &record, selectedDate: selectedDate) { result in
                    
                    switch result {
                    
                    case .success:
                        
                        print("onTapUploadRecord, success")
                        
                    case .failure(let error):
                        
                        print("onTapUploadRecord, failure: \(error)")
                    }
                }
            }
            
            cell.onCancelButtonPressed = { [unowned self] in
                self.navigationController?.popViewController(animated: true)
                self.tabBarController?.tabBar.isHidden = false
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
}
