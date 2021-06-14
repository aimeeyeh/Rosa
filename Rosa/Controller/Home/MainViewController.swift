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
    @IBOutlet weak var noSleepRecord: UILabel!
    @IBOutlet weak var noWaterRecord: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var frontalFirstDay: UILabel!
    @IBOutlet weak var frontalToday: UILabel!
    @IBOutlet weak var frontalBeforeImage: UIImageView!
    @IBOutlet weak var frontalAfterImage: UIImageView!
    @IBOutlet weak var frontalNoComparisonLabel: UILabel!
    @IBOutlet weak var frontalStackView: UIStackView!
    
    @IBOutlet weak var leftFirstDay: UILabel!
    @IBOutlet weak var leftToday: UILabel!
    @IBOutlet weak var leftBefore: UIImageView!
    @IBOutlet weak var leftAfter: UIImageView!
    @IBOutlet weak var leftNoComparisonLabel: UILabel!
    @IBOutlet weak var leftStackView: UIStackView!
    
    @IBOutlet weak var rightFirstDay: UILabel!
    @IBOutlet weak var rightLastDay: UILabel!
    @IBOutlet weak var rightBefore: UIImageView!
    @IBOutlet weak var rightAfter: UIImageView!
    @IBOutlet weak var rightNoComparisonLabel: UILabel!
    @IBOutlet weak var rightStackView: UIStackView!

    func createPastSevenDays() -> [Date] {
        var past7Days = [Date]()
        
        let today = Date()
        let calendar = Calendar.current
        let todayStartTime = calendar.startOfDay(for: today)
        
        for index in -6 ... 0 {
            var endDateComponents = DateComponents()
            endDateComponents.day = index
            if let day = calendar.date(byAdding: endDateComponents, to: todayStartTime) {
                past7Days.append(day)
            }
        }
        return past7Days
    }
    
    var sleepLineChartYValues: [ChartDataEntry] = []
    var waterBarChartYValues: [ChartDataEntry] = []
    
    func setUpSleepChartData() {
        for (index, sleep) in sleepArray.enumerated() {
            sleepLineChartYValues.append(ChartDataEntry(x: Double(index+1), y: sleep))
//            print("x: \(Double(index+1)), y: \(sleep)")
        }
        configureSleepLineChart()
    }
    
    func setUpWaterChartData() {
        for (index, water) in waterArray.enumerated() {
            waterBarChartYValues.append(BarChartDataEntry(x: Double(index+1), y: Double(water*250)))
//            print("x: \(Double(index+1)), y: \(water)")
        }
        configureWaterBarChart()
    }
    
    var sleepArray: [Double] = []

    var waterArray: [Int] = []
    
    var last7DayRecords: [Record] = [] {
        didSet {
            if last7DayRecords.count == 0 {
                waterChartView.isHidden = true
                sleepLineChartView.isHidden = true
//                noWaterRecord.isHidden = false
//                noSleepRecord.isHidden = false
            } else {
                waterChartView.isHidden = false
                sleepLineChartView.isHidden = false
//                noWaterRecord.isHidden = true
//                noSleepRecord.isHidden = true
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
        noWaterRecord.isHidden = true
        noSleepRecord.isHidden = true
        
        if let query = UserDefaults.standard.string(forKey: "query") {
            let defaults = UserDefaults.standard
            defaults.set(nil, forKey: "query")
            ArticleManager.shared.fetchArticle(articleID: query) { [weak self] result in
                
                switch result {
                
                case .success(let article):
                    
                    self?.deeplinkArticle = article
                    self?.openArticleDetail()
                    
                case .failure(let error):
                    
                    print("fetchData.failure: \(error)")
                }
            }
            
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
    
    func openArticleDetail() {
            if let articleDetailVC = UIStoryboard(name: "Articles", bundle: nil)
                .instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController {
                guard let deeplinkArticle = deeplinkArticle else { return }
                articleDetailVC.article = deeplinkArticle
                self.navigationController?.pushViewController(articleDetailVC, animated: true)
            }
    }
    
    func resetData() {
        self.sleepArray = []
        self.waterArray = []
        self.sleepLineChartYValues = []
        self.waterBarChartYValues = []
    }
    
    func configurePhotoView() {
        
        let sevenDays = createPastSevenDays()
        let firstDay = sevenDays[0].formatForMainPage()
        let today = sevenDays[6].formatForMainPage()
        
        func hideFrontalCard() {
            frontalFirstDay.isHidden = true
            frontalToday.isHidden = true
            frontalStackView.isHidden = true
            frontalNoComparisonLabel.isHidden = false
        }
        
        func hideLeftCard() {
            leftFirstDay.isHidden = true
            leftToday.isHidden = true
            leftStackView.isHidden = true
            leftNoComparisonLabel.isHidden = false
        }
        
        func hideRightCard() {
            rightFirstDay.isHidden = true
            rightLastDay.isHidden = true
            rightStackView.isHidden = true
            rightNoComparisonLabel.isHidden = false
        }
        
        if last7DayRecords.count < 7 {
            hideFrontalCard()
            hideLeftCard()
            hideRightCard()
            
        } else {
            
            let firstDayFrontalPhoto = last7DayRecords[0].fullPhoto
            let todayFrontalPhoto = last7DayRecords[6].fullPhoto
            if firstDayFrontalPhoto == "" || todayFrontalPhoto == "" {
                hideFrontalCard()
            } else {
                frontalNoComparisonLabel.isHidden = true
                frontalFirstDay.isHidden = false
                frontalToday.isHidden = false
                frontalStackView.isHidden = false
                frontalFirstDay.text = firstDay
                frontalToday.text = today
                frontalBeforeImage.kf.setImage(with: URL(string: firstDayFrontalPhoto))
                frontalAfterImage.kf.setImage(with: URL(string: todayFrontalPhoto))
            }
            
            let firstDayLeftPhoto = last7DayRecords[0].leftPhoto
            let todayLeftPhoto = last7DayRecords[6].leftPhoto
            if firstDayLeftPhoto == "" || todayLeftPhoto == "" {
                hideLeftCard()
            } else {
                leftNoComparisonLabel.isHidden = true
                leftFirstDay.isHidden = false
                leftToday.isHidden = false
                leftStackView.isHidden = false
                leftFirstDay.text = firstDay
                leftToday.text = today
                leftBefore.kf.setImage(with: URL(string: firstDayLeftPhoto))
                leftAfter.kf.setImage(with: URL(string: todayLeftPhoto))
            }
            
            let firstDayRightPhoto = last7DayRecords[0].rightPhoto
            let todayRightPhoto = last7DayRecords[6].rightPhoto
            if firstDayRightPhoto == "" || todayRightPhoto == "" {
                hideRightCard()
            } else {
                rightNoComparisonLabel.isHidden = true
                rightFirstDay.isHidden = false
                rightLastDay.isHidden = false
                rightStackView.isHidden = false
                rightFirstDay.text = firstDay
                rightLastDay.text = today
                rightBefore.kf.setImage(with: URL(string: firstDayRightPhoto))
                rightAfter.kf.setImage(with: URL(string: todayRightPhoto))
            }
        }
    }
    
    func configureViews() {
        challengeProgressView.shadowDecorate()
        waterProgressView.shadowDecorate()
        sleepProgressView.shadowDecorate()
        priceView.shadowDecorate()
        photoComparisonView.shadowDecorate()
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
        let data = BarChartData(dataSets: [dataSet])
        waterChartView.data = data
        waterChartView.xAxis.drawGridLinesEnabled = false
        waterChartView.xAxis.labelPosition = .bottom
        dataSet.drawValuesEnabled = false
        let topAxis = waterChartView.leftAxis
        topAxis.drawGridLinesEnabled = false
        topAxis.drawLabelsEnabled = false
        topAxis.drawAxisLineEnabled = false
        waterChartView.rightAxis.drawGridLinesEnabled = false
        waterChartView.rightAxis.granularityEnabled = true
        waterChartView.rightAxis.granularity = 750
        waterChartView.maxVisibleCount = 60
        waterChartView.notifyDataSetChanged()
        waterChartView.animate(yAxisDuration: 2.0)
        waterChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 7)
        waterChartView.xAxis.valueFormatter = MyXAxisFormatter()
    }
    
    func configureSleepLineChart() {
        let sleepColor = UIColor.rgb(red: 178, green: 228, blue: 157, alpha: 1.0)
        let set = LineChartDataSet(entries: sleepLineChartYValues, label: "Sleeping Hours".localized())
        let data = LineChartData(dataSet: set)
        set.drawCirclesEnabled = false
        set.mode = .cubicBezier
        set.setColor(sleepColor)
        set.lineWidth = 3
        set.fill = Fill(color: sleepColor)
        set.fillAlpha = 0.8
        set.drawFilledEnabled = true
        data.setDrawValues(false)
        sleepLineChartView.data = data
        sleepLineChartView.rightAxis.enabled = false
        sleepLineChartView.xAxis.labelPosition = .bottom
        let yAxis = sleepLineChartView.leftAxis
        yAxis.drawGridLinesEnabled = false
//        yAxis.granularity = 0.5
        sleepLineChartView.xAxis.drawGridLinesEnabled = false
        sleepLineChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        sleepLineChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 7)
        sleepLineChartView.xAxis.valueFormatter = MyXAxisFormatter()
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

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        pageControl.currentPage = Int(page)
    }
}
