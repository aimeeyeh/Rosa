//
//  ViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit
import MKRingProgressView
import Charts

//class MyXAxisFormatter: IAxisValueFormatter {
//    var days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
//
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//
//        let val = Int(value - 1)
//
//        if val >= 0 && val < days.count {
//            return days[Int(val)]
//        }
//        return ""
//
//    }
//}

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
                noWaterRecord.isHidden = false
                noSleepRecord.isHidden = false
            } else {
                waterChartView.isHidden = false
                sleepLineChartView.isHidden = false
                noWaterRecord.isHidden = true
                noSleepRecord.isHidden = true
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
            UIView.animate(withDuration: 1.0) {
                let progress = Double(self.overallProgress) / 100.0
                self.ringProgressView.progress = progress
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        configureViews()
        configureProgressView()
//        self.sleepLineChartView.ishidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        sleepArray = []
        waterArray = []
        fetchChallenge(date: Date())
        fetchPreviousRecords()
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
        let dataSet = BarChartDataSet(entries: waterBarChartYValues, label: "Water (ml)")
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
        waterChartView.rightAxis.granularity = 500
        waterChartView.maxVisibleCount = 60
        waterChartView.notifyDataSetChanged()
        waterChartView.animate(yAxisDuration: 2.0)
        waterChartView.xAxis.labelFont = UIFont.systemFont(ofSize: 7)
        waterChartView.xAxis.valueFormatter = MyXAxisFormatter()
    }
    
    func configureSleepLineChart() {
        let sleepColor = UIColor.rgb(red: 178, green: 228, blue: 157, alpha: 1.0)
        let set = LineChartDataSet(entries: sleepLineChartYValues, label: "Sleeping Hours")
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
//        yAxis.granularity = 0.25
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
        RecordManager.shared.fetchPast7daysRecords() { [weak self] result in
            
            switch result {
            
            case .success(let records):
                
                self?.last7DayRecords = records
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }

}
