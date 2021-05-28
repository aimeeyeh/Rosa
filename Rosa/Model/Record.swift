//
//  Record.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Record: Codable {
    var id: String
    var date: Date
    var weather: String
    var fullPhoto: String
    var leftPhoto: String
    var rightPhoto: String
    var feeling: String
    var water: Int
    var sleep: Double
    var mealDairyFree: Bool
    var mealGlutenFree: Bool
    var mealJunkFree: Bool
    var mealSugarFree: Bool
    var outdoor: Bool
    var makeup: Bool
    var menstrual: Bool
    var remark: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case weather
        case fullPhoto
        case leftPhoto
        case rightPhoto
        case feeling
        case water
        case sleep
        case mealDairyFree
        case mealGlutenFree
        case mealJunkFree
        case mealSugarFree
        case outdoor
        case makeup
        case menstrual
        case remark
    }
    
//    var toDict: [String: Any] {
//        return [
//            "id": id as Any,
//            "date": date as Any,
//            "weather": weather as Any,
//            "photos": photos as Any,
//            "feeling": feeling as Any,
//            "water": water as Any,
//            "sleep": sleep as Any,
//            "mealDairyFree": mealDairyFree as Any,
//            "mealGlutenFree": mealGlutenFree as Any,
//            "mealJunkFree": mealJunkFree as Any,
//            "mealSugarFree": mealSugarFree as Any,
//            "outdoor": outdoor as Any,
//            "makeup": makeup as Any,
//            "menstrual": menstrual as Any,
//            "remark": remark as Any
//        ]
//    }
}
