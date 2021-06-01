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
            document.collection("comments").document("default").setData(["id": "default"])
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
    
    func fetchComments(articleID: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
        
        let queryCollection = database.collection("articles").document(articleID).collection("comments")
        queryCollection.addSnapshotListener { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                var comments = [Comment]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let comment = try document.data(as: Comment.self, decoder: Firestore.Decoder()) {
                            comments.append(comment)
                        }
                        
                    } catch {
                        print(error)
                    }
                }
                completion(.success(comments))
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
