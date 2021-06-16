//
//  ViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit
import MKRingProgressView
import Charts
import Kingfisher

class MainViewController: UIViewController, ChartViewDelegate {

    @IBOutlet weak var challengeProgressView: UIView!
    @IBOutlet weak var challengeProgressLabel: UILabel!
    @IBOutlet weak var waterProgressView: UIView!
    @IBOutlet weak var sleepProgressView: UIView!
    @IBOutlet weak var priceView: UIView!
    @IBOutlet weak var photoComparisonView: UIView!
    @IBOutlet weak var ringProgressView: RingProgressView!
    @IBOutlet weak var waterChartView: HorizontalBarChartView!
    @IBOutlet weak var sleepLineChartView: LineChartView!
    @IBOutlet weak var noSleepRecordLabel: UILabel!
    @IBOutlet weak var noWaterRecordLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var frontalFirstDateLabel: UILabel!
    @IBOutlet weak var frontalTodaysDateLabel: UILabel!
    @IBOutlet weak var frontalBeforeImage: UIImageView!
    @IBOutlet weak var frontalAfterImage: UIImageView!
    @IBOutlet weak var frontalNoComparisonLabel: UILabel!
    @IBOutlet weak var frontalStackView: UIStackView!
    
    @IBOutlet weak var leftFirstDateLabel: UILabel!
    @IBOutlet weak var leftTodaysDateLabel: UILabel!
    @IBOutlet weak var leftBeforeImage: UIImageView!
    @IBOutlet weak var leftAfterImage: UIImageView!
    @IBOutlet weak var leftNoComparisonLabel: UILabel!
    @IBOutlet weak var leftStackView: UIStackView!
    
    @IBOutlet weak var rightFirstDateLabel: UILabel!
    @IBOutlet weak var rightTodaysDateLabel: UILabel!
    @IBOutlet weak var rightBeforeImage: UIImageView!
    @IBOutlet weak var rightAfterImage: UIImageView!
    @IBOutlet weak var rightNoComparisonLabel: UILabel!
    @IBOutlet weak var rightStackView: UIStackView!
    
    var sleepLineChartYValues: [ChartDataEntry] = []
    
    var waterBarChartYValues: [ChartDataEntry] = []
    
    var sleepArray: [Double] = []

    var waterArray: [Int] = []
    
    var last7DayRecords: [Record] = [] {
        
        didSet {
            
            if last7DayRecords.count == 0 {
                waterChartView.isHidden = true
                sleepLineChartView.isHidden = true
                
            } else {
                
                waterChartView.isHidden = false
                sleepLineChartView.isHidden = false
                
                let past7Days = createPastSevenDays()
                for day in past7Days {
                    let filteredRecords = last7DayRecords.filter { $0.date == day }
                    if filteredRecords.count > 0 {
                        sleepArray.append(filteredRecords[0].sleep)
                        waterArray.append(filteredRecords[0].water)
                    } else {
                        sleepArray.append(0.0)
                        waterArray.append(0)
                    }
                }
                
                setUpSleepChartData()
                setUpWaterChartData()
                configurePhotoView()
            }
        }
    }
    
    var challenges: [Challenge] = [] {
        didSet {
            ringProgressView.reloadInputViews()
            waterChartView.reloadInputViews()
            if challenges.count == 0 {
                return
            } else {
                self.overallProgress = Double(challenges[0].progress)/30 * 100
            }
        }
    }
    
    var overallProgress: Double = 0.0 {
        didSet {
            challengeProgressLabel.text = "\(lround(overallProgress))%"
            self.ringProgressView.isHidden = false
            UIView.animate(withDuration: 1.0) {
                let progress = Double(self.overallProgress) / 100.0
                self.ringProgressView.progress = progress
            }
        }
    }
    
    var deeplinkArticle: Article?
    
    override func viewDidLoad() {

        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        hideNoChartLabels()
        if let query = UserDefaults.standard.string(forKey: "query") {
            fetchDeeplinkArticle(query)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.resetData()
        fetchChallenge(date: Date())
        fetchPreviousRecords()
        configureViews()
        configureProgressView()
        configurePhotoView()
        
    }
    
    // MARK: - Deeplink
    
    fileprivate func fetchDeeplinkArticle(_ query: String) {
        
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "query")
        ArticleManager.shared.fetchArticle(articleID: query) { [weak self] result in
            
            switch result {
            
            case .success(let article):
                
                self?.deeplinkArticle = article
                self?.showArticleFromDeeplink()
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
        
    }
    
    func showArticleFromDeeplink() {
        
        if let articleDetailVC = UIStoryboard(name: "Articles", bundle: nil)
            .instantiateViewController(
                withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
            guard let deeplinkArticle = deeplinkArticle else { return }
            articleDetailVC.article = deeplinkArticle
            self.navigationController?.pushViewController(articleDetailVC, animated: true)
        }
        
    }
    
    // MARK: - challengeProgessView / waterBarChart / sleepLineChart
        
    fileprivate func hideNoChartLabels() {
        noWaterRecordLabel.isHidden = true
        noSleepRecordLabel.isHidden = true
    }
    
    func createPastSevenDays() -> [Date] {
        
        var past7Days = [Date]()
        
        let today = Date()
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: today)
        
        for index in -6 ... 0 {
            var endDateComponents = DateComponents()
            endDateComponents.day = index
            if let day = calendar.date(byAdding: endDateComponents, to: startOfToday) {
                past7Days.append(day)
            }
        }
        return past7Days
    }
    
    func setUpSleepChartData() {
        for (index, sleep) in sleepArray.enumerated() {
            sleepLineChartYValues.append(ChartDataEntry(x: Double(index+1), y: sleep))
        }
        configureSleepLineChart()
    }
    
    func setUpWaterChartData() {
        for (index, water) in waterArray.enumerated() {
            waterBarChartYValues.append(BarChartDataEntry(x: Double(index+1), y: Double(water*250)))
        }
        configureWaterBarChart()
    }
    
    func configureViews() {
        challengeProgressView.shadowDecorate()
        waterProgressView.shadowDecorate()
        sleepProgressView.shadowDecorate()
        priceView.shadowDecorate()
        photoComparisonView.shadowDecorate()
    }
    
    func resetData() {
        self.sleepArray = []
        self.waterArray = []
        self.sleepLineChartYValues = []
        self.waterBarChartYValues = []
    }
    
    func configureProgressView() {
        
        ringProgressView.startColor = UIColor(red: 1.00, green: 0.84, blue: 0.64, alpha: 1.00)
        ringProgressView.endColor = .orange
        ringProgressView.backgroundRingColor = UIColor(red: 1.00, green: 0.84, blue: 0.64, alpha: 0.5)
        ringProgressView.ringWidth = 14
        ringProgressView.hidesRingForZeroProgress = true
        ringProgressView.gradientImageScale = 0.5
        ringProgressView.shadowOpacity = 0.0
        ringProgressView.allowsAntialiasing = false
        ringProgressView.style = .round
        
    }
    
    func configureWaterBarChart() {
        
        let dataSet = BarChartDataSet(entries: waterBarChartYValues, label: "Water (ml)".localized())
        dataSet.drawValuesEnabled = false
        
        waterChartView.data = BarChartData(dataSets: [dataSet])
        
        let dateAxis = waterChartView.xAxis
        dateAxis.drawGridLinesEnabled = false
        dateAxis.labelPosition = .bottom
        dateAxis.labelFont = UIFont.systemFont(ofSize: 7)
        dateAxis.valueFormatter = MyXAxisFormatter()
        
        let waterAxis = waterChartView.rightAxis
        waterAxis.drawGridLinesEnabled = false
        waterAxis.granularityEnabled = true
        waterAxis.granularity = 750
        
        let topAxis = waterChartView.leftAxis
        topAxis.drawGridLinesEnabled = false
        topAxis.drawLabelsEnabled = false
        topAxis.drawAxisLineEnabled = false
        
        waterChartView.notifyDataSetChanged()
        waterChartView.animate(yAxisDuration: 2.0)
        
    }
    
    func configureSleepLineChart() {
        
        let dataSet = LineChartDataSet(entries: sleepLineChartYValues, label: "Sleeping Hours".localized())
        let sleepColor = UIColor.rgb(red: 178, green: 228, blue: 157, alpha: 1.0)
        dataSet.drawCirclesEnabled = false
        dataSet.drawValuesEnabled = false
        dataSet.mode = .cubicBezier
        dataSet.setColor(sleepColor)
        dataSet.lineWidth = 3
        dataSet.fill = Fill(color: sleepColor)
        dataSet.fillAlpha = 0.8
        dataSet.drawFilledEnabled = true

        sleepLineChartView.data = LineChartData(dataSet: dataSet)
        
        let xAxis = sleepLineChartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.drawGridLinesEnabled = false
        xAxis.labelFont = UIFont.systemFont(ofSize: 7)
        xAxis.valueFormatter = MyXAxisFormatter()
        
        let yAxis = sleepLineChartView.leftAxis
        yAxis.drawGridLinesEnabled = false
        
        sleepLineChartView.rightAxis.enabled = false
        sleepLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        
    }
    
    // MARK: - Model related functions
    
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
    
    func fetchPreviousRecords() {
        
        RecordManager.shared.fetchPast7daysRecords { [weak self] result in
            
            switch result {
            
            case .success(let records):
                
                self?.last7DayRecords = records
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }

}

// MARK: - Photo comparisons & ScrollViewDelegate

extension MainViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        pageControl.currentPage = Int(page)
        
    }
    
    fileprivate func hideFrontalCard() {
        frontalFirstDateLabel.isHidden = true
        frontalTodaysDateLabel.isHidden = true
        frontalStackView.isHidden = true
        frontalNoComparisonLabel.isHidden = false
    }
    
    fileprivate func hideLeftCard() {
        leftFirstDateLabel.isHidden = true
        leftTodaysDateLabel.isHidden = true
        leftStackView.isHidden = true
        leftNoComparisonLabel.isHidden = false
    }
    
    fileprivate func hideRightCard() {
        rightFirstDateLabel.isHidden = true
        rightTodaysDateLabel.isHidden = true
        rightStackView.isHidden = true
        rightNoComparisonLabel.isHidden = false
    }
    
    fileprivate func showFrontalCard() {
        frontalNoComparisonLabel.isHidden = true
        frontalFirstDateLabel.isHidden = false
        frontalTodaysDateLabel.isHidden = false
        frontalStackView.isHidden = false
    }
    
    fileprivate func showLeftCard() {
        leftNoComparisonLabel.isHidden = true
        leftFirstDateLabel.isHidden = false
        leftTodaysDateLabel.isHidden = false
        leftStackView.isHidden = false
    }
    
    fileprivate func showRightCard() {
        rightNoComparisonLabel.isHidden = true
        rightFirstDateLabel.isHidden = false
        rightTodaysDateLabel.isHidden = false
        rightStackView.isHidden = false
    }
    
    func configurePhotoView() {
        
        let pastSevenDays = createPastSevenDays()
        let sevenDaysAgo = pastSevenDays[0].formatForMainPage()
        let today = pastSevenDays[6].formatForMainPage()
                
        if last7DayRecords.count < 7 {
            hideFrontalCard()
            hideLeftCard()
            hideRightCard()
            
        } else {
            
            let firstDayFrontalPhoto = last7DayRecords[0].fullPhoto
            let todayFrontalPhoto = last7DayRecords[6].fullPhoto
            let firstDayLeftPhoto = last7DayRecords[0].leftPhoto
            let todayLeftPhoto = last7DayRecords[6].leftPhoto
            let firstDayRightPhoto = last7DayRecords[0].rightPhoto
            let todayRightPhoto = last7DayRecords[6].rightPhoto
            
            if firstDayFrontalPhoto.isEmpty || todayFrontalPhoto.isEmpty {
                hideFrontalCard()
                
            } else {
                
                showFrontalCard()
                frontalFirstDateLabel.text = sevenDaysAgo
                frontalTodaysDateLabel.text = today
                frontalBeforeImage.kf.setImage(with: URL(string: firstDayFrontalPhoto))
                frontalAfterImage.kf.setImage(with: URL(string: todayFrontalPhoto))
            }
            
            if firstDayLeftPhoto.isEmpty || todayLeftPhoto.isEmpty {
                hideLeftCard()
                
            } else {
                
                showLeftCard()
                leftFirstDateLabel.text = sevenDaysAgo
                leftTodaysDateLabel.text = today
                leftBeforeImage.kf.setImage(with: URL(string: firstDayLeftPhoto))
                leftAfterImage.kf.setImage(with: URL(string: todayLeftPhoto))
            }
            
            if firstDayRightPhoto.isEmpty || todayRightPhoto.isEmpty {
                hideRightCard()
                
            } else {
                
                showRightCard()
                rightFirstDateLabel.text = sevenDaysAgo
                rightTodaysDateLabel.text = today
                rightBeforeImage.kf.setImage(with: URL(string: firstDayRightPhoto))
                rightAfterImage.kf.setImage(with: URL(string: todayRightPhoto))
            }
        }
    }
    
}
