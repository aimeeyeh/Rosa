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
    
    func fetchAllArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        
        let queryCollection = database.collection("articles")
        queryCollection.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                var articles = [Article]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let article = try document.data(as: Article.self, decoder: Firestore.Decoder()) {
                            articles.append(article)
                        }
                        
                    } catch {
                        print(error)
                    }
                }
                completion(.success(articles))
            }
            
        }
    }
    
    func queryCategory(category: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        let queryCollection = database.collection("articles")
        queryCollection.whereField("category", isEqualTo: category)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    var articles = [Article]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            if let article = try document.data(as: Article.self, decoder: Firestore.Decoder()) {
                                articles.append(article)
                            }
                            
                        } catch {
                            completion(.failure(error))
                        }
                    }
                    completion(.success(articles))
                    
                }
            }
    }
    
}
