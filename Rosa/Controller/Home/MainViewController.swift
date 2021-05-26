//
//  ViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/12.
//

import UIKit
import MKRingProgressView
import Charts

// class MyXAxisFormatter: IAxisValueFormatter {
//    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
//        <#code#>
//    }
// }

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
    
    var challenges: [Challenge] = [] {
        didSet {
            ringProgressView.reloadInputViews()
            waterChartView.reloadInputViews()
            self.overallProgress = Double(challenges[0].progress)/30 * 100
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
        configureWaterBarChart()
        fetchChallenge(date: Date())

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
        
        let entry1 = BarChartDataEntry(x: 1.0, y: 2200)
        let entry2 = BarChartDataEntry(x: 2.0, y: 2500)
        let entry3 = BarChartDataEntry(x: 3.0, y: 1800)
        let entry4 = BarChartDataEntry(x: 4.0, y: 1600)
        let entry5 = BarChartDataEntry(x: 5.0, y: 1900)
        let entry6 = BarChartDataEntry(x: 6.0, y: 1500)
        let entry7 = BarChartDataEntry(x: 7.0, y: 2200)
        let entries = [entry1, entry2, entry3, entry4, entry5, entry6, entry7]
        let dataSet = BarChartDataSet(entries: entries, label: "Water (ml)")
        let data = BarChartData(dataSets: [dataSet])
        waterChartView.data = data
        
        waterChartView.xAxis.drawGridLinesEnabled = false
        waterChartView.xAxis.labelPosition = .bottom
        waterChartView.xAxis.drawAxisLineEnabled = false
        waterChartView.leftAxis.drawGridLinesEnabled = false
        waterChartView.leftAxis.drawLabelsEnabled = false
        waterChartView.leftAxis.drawAxisLineEnabled = false
//        waterChartView.rightAxis.drawGridLinesEnabled = false
//        waterChartView.rightAxis.drawAxisLineEnabled = false
        waterChartView.rightAxis.granularityEnabled = true
        waterChartView.rightAxis.granularity = 500
        waterChartView.maxVisibleCount = 60
        waterChartView.notifyDataSetChanged()
        waterChartView.animate(yAxisDuration: 2.0)
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

}
