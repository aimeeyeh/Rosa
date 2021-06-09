//
//  Date+Extension.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/28.
//

import Foundation

extension Date {
    
    func formatToDateOnly() -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let date = dateFormatter.string(from: self)
        
        return date
    }
    
    func formatToDateWithoutYearOnly() -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"

        let date = dateFormatter.string(from: self)
        
        return date
    }
    
    func formatForMainPage() -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"

        let date = dateFormatter.string(from: self)
        
        return date
    }
    
}
