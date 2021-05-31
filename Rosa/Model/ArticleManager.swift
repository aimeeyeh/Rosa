//
//  ArticleManager.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/30.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ArticleManager {
    
    static let shared = ArticleManager()
    
    lazy var database = Firestore.firestore()
    
    let userID = UserDefaults.standard.string(forKey: "userID")
    let defaultID = "Aimee"
    
    func postArticle(article: inout Article) {
        
        let document = database.collection("articles").document()
        article.id = document.documentID
        article.createdTime = Date()
        article.author = userID ?? "Anonymous"
        
        do {
            try  document.setData(from: article)
            print("Article Posted Success")
        } catch let error {
            print("Error posting article to Firestore: \(error)")
        }
    }
    
}
