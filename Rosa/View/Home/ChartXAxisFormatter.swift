//
//  ChartXAxisFormatter.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/30.
//

import Foundation
import Charts

class MyXAxisFormatter: IAxisValueFormatter {
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd"
        return formatter
    }()
    
    var past7Days = [String]()
    
    func createPastSevenDays() {
        
        let today = Date()
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: today)
        
        for index in -6 ... 0 {
            var endDateComponents = DateComponents()
            endDateComponents.day = index
            if let day = calendar.date(byAdding: endDateComponents, to: startOfToday) {
                let dateString = self.dateFormatter.string(from: day)
                self.past7Days.append(dateString)
            }
        }
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        createPastSevenDays()
        let val = Int(value - 1)
        if val >= 0 && val < past7Days.count {
            return past7Days[Int(val)]
        }
        return ""
    }
    
}
