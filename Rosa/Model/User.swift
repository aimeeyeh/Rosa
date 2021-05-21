//
//  User.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/21.
//

import Foundation

struct User: Codable {
    
    var id: String
    var name: String
    var photo: String
    var location: Location
    var challenge: [Challenge]
    var record: [Record]
    var likedArticles: [String]
    var followed: [String]
    var followers: [String]
    var blacklist: [String]
    
}

struct Location: Codable {
    
    var latitude: Double
    var longitude: Double
    
    var toDict: [String: Any] {
        return [
            "latitude": latitude as Any,
            "longitude": longitude as Any
        ]
    }
    
}
