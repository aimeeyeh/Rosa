//
//  User.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/21.
//

import Foundation
import AuthenticationServices

struct User: Codable {
    let id: String
    let name: String
    var photo: String?
    var likedArticles: [String]?
    var followed: [String]?
    var followers: [String]?
    var blocklist: [String]?
}
