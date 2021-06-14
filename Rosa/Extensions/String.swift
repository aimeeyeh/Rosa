//
//  String.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/14.
//

import Foundation
import UIKit

extension String {
    func localized() -> String {
        return NSLocalizedString(self,
                                 tableName: "Localizable",
                                 bundle: .main,
                                 value: self,
                                 comment: self)
    }
}


