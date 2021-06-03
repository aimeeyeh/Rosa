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
//    var location: Location?
//    var challenge: [Challenge]
//    var record: [Record]
    var likedArticles: [String]?
    var followed: [String]?
    var followers: [String]?
    var blocklist: [String]?
    
//    init(credentials: ASAuthorizationAppleIDCredential) {
//        self.id = credentials.user
//        self.name = credentials.fullName?.givenName ?? ""
//        self.photo = ""
//        self.likedArticles = []
//        self.followed = []
//        self.followers = []
//        self.blocklist = []
//    }
    
}

// struct Location: Codable {
//
//    var latitude: Double
//    var longitude: Double
//
//    var toDict: [String: Any] {
//        return [
//            "latitude": latitude as Any,
//            "longitude": longitude as Any
//        ]
//    }
// }
