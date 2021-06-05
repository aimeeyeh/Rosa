//
//  Article.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/21.
//

import Foundation

struct Article: Codable {
    
    var id: String
    var authorID: String
    var authorName: String
    var authorPhoto: String
    var category: String
    var content: String
    var createdTime: Date
    var likes: Int
    var photos: [String]
    var title: String
}

struct Comment: Codable {
    var id: String
    var authorID: String
    var authorName: String
    var authorPhoto: String 
    var content: String
    var date: Date
}
