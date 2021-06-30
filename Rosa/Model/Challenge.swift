//
//  Challenge.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/21.
//

import Foundation
import UIKit

struct Challenge: Codable, Equatable {
    var category: String
    var challengeImage: String
    var id: String
    var progress: Int
    var setUpDate: Date
    var challengeTitle: String
    var isFirstDay: Bool
    var isChecked: Bool
}
