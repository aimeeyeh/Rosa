//
//  Challenge.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/21.
//

import Foundation
import UIKit

struct Challenge: Codable {
    var category: String
    var challengeImage: String
    var id: String
    var progress: Int
    var setUpDate: Date
    var challengeTitle: String
    var isFirstDay: Bool
    var isChecked: Bool
    
//    var toDict: [String: Any] {
//        return [
//            "category": category as Any,
//            "icon": icon as Any,
//            "id": id as Any,
//            "progress": progress as Any,
//            "setUpDate": setUpDate as Any,
//            "title": title as Any
//        ]
//    }
}
