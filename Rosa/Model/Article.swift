//
//  Article.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/21.
//

import Foundation

struct Article: Codable {
    
    var id: String
    var author: String
    var category: String
    var content: String
    var createdTime: Double
    var likes: Int
    var photos: [String]
    var title: String
    var comments: [Comment]
    
//    var toDict: [String: Any] {
//        return [
//            "id": id as Any,
//            "author": author as Any,
//            "category": category as Any,
//            "content": content as Any,
//            "createdTime": createdTime as Any,
//            "likes": likes as Any,
//            "photos": photos as Any,
//            "title": title as Any,
//            "comments": comments as Any
//        ]
//    }
}

struct Comment: Codable {
    var id: String
    var user: String
    var content: String
    var date: Double
    
//    var toDict: [String: Any] {
//        return [
//            "id": id as Any,
//            "user": user as Any,
//            "content": content as Any,
//            "date": date as Any
//        ]
//    }
}
