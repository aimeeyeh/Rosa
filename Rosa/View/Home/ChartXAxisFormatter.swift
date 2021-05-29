//
//  ChartXAxisFormatter.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/30.
//

import Foundation
import Charts

class MyXAxisFormatter: IAxisValueFormatter {
    var days = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        let val = Int(value - 1)
        
        if val >= 0 && val < days.count {
            return days[Int(val)]
        }
        return ""
        
    }
}
