//
//  Challenge.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/21.
//

import Foundation

struct Challenge: Codable {
    var category: String
    var icon: String
    var id: String
    var progress: Int
    var setUpDate: Double
    var title: String
    
    var toDict: [String: Any] {
        return [
            "category": category as Any,
            "icon": icon as Any,
            "id": id as Any,
            "progress": progress as Any,
            "setUpDate": setUpDate as Any,
            "title": title as Any
        ]
    }
}
