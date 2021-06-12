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
    
    let user = UserManager.shared.currentUser
    
    func postArticle(article: inout Article) {
        
        // update articles
        
        let document = database.collection("articles").document()
        article.id = document.documentID
        
        do {
            try  document.setData(from: article)
            
            let commentData: [String: Any] = [
                "authorID": "default",
                "authorName": "default",
                "authorPhoto": "default",
                "content": "default",
                "id": "default",
                "date": Date()
            ]
            
            document.collection("comments").document("default").setData(commentData)
            
            print("Article Posted Success")
            
        } catch let error {
            print("Error posting article to Firestore: \(error)")
        }
    }
    
    func fetchAllArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        
        let queryCollection = database.collection("articles").order(by: "createdTime", descending: true)
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
    
    func postComment(documentID: String, comment: String) {
        
        let userID = user?.id
        let userName = user?.name
        guard let userPhoto = user?.photo else { return }
        
        let document = database.collection("articles").document(documentID).collection("comments").document()
        let comment = Comment(id: document.documentID,
                              authorID: userID ?? "Fail",
                              authorName: userName ?? "Anonymous",
                              authorPhoto: userPhoto ,
                              content: comment,
                              date: Date())

        do {
            try  document.setData(from: comment)
            
            print("Comment Posted Success")
            
        } catch let error {
            print("Error posting comment to Firestore: \(error)")
        }
    }
    
    func fetchComments(articleID: String, completion: @escaping (Result<[Comment], Error>) -> Void) {
        
        let queryCollection = database.collection("articles").document(articleID).collection("comments")
            .order(by: "date", descending: false)
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
            .getDocuments { (querySnapshot, err) in
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
    
    func likeArticles(articleID: String, currentLikes: Int) {
        
        // update user
        guard let userID = user?.id else { return }
        
        let document = database.collection("user").document(userID)

        document.updateData([
                "likedArticles": FieldValue.arrayUnion([articleID])
            ])
        
        // update article
        
        let subtractedNumber = currentLikes + 1
        let articleDocument = database.collection("articles").document(articleID)
        articleDocument.updateData([
            "likes": subtractedNumber
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }

    }
    
    func unLikeArticles(articleID: String, currentLikes: Int) {
        
        // update user
        guard let userID = user?.id else { return }
        
        let document = database.collection("user").document(userID)

        document.updateData([
                "likedArticles": FieldValue.arrayRemove([articleID])
            ])
        
        // update article
        let subtractedNumber = currentLikes - 1
        let articleDocument = database.collection("articles").document(articleID)
        articleDocument.updateData([
            "likes": subtractedNumber
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
    }
    
    func addToFollowed(authorID: String) {
        
        guard let userID = user?.id else { return }
        
        let currentUserDocument = database.collection("user").document(userID)

        currentUserDocument.updateData([
                "followed": FieldValue.arrayUnion([authorID])
            ])
        
        let followeduserDocument = database.collection("user").document(authorID)
        
        followeduserDocument.updateData([
                "followers": FieldValue.arrayUnion([userID])
            ])
        
    }
    
    func removeFromFollowed(authorID: String) {
        
        guard let userID = user?.id else { return }
        
        let currentUserDocument = database.collection("user").document(userID)

        currentUserDocument.updateData([
                "followed": FieldValue.arrayRemove([authorID])
            ])
        
        let followeduserDocument = database.collection("user").document(authorID)
        
        followeduserDocument.updateData([
                "followers": FieldValue.arrayRemove([userID])
            ])
        
    }
    
    func fetchPostedArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        
        guard let userID = user?.id else { return }
        let queryCollection = database.collection("articles").order(by: "createdTime", descending: true)
        queryCollection.whereField("authorID", isEqualTo: userID)
            .getDocuments { (querySnapshot, err) in
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
    
    func fetchLikedArticles(completion: @escaping (Result<[Article], Error>) -> Void) {
        
        let user = UserManager.shared.currentUser
        guard let userLikedArticles = user?.likedArticles else { return }
        
        let queryCollection = database.collection("articles").order(by: "createdTime", descending: true)
        queryCollection.whereField("id", in: userLikedArticles)
            .getDocuments { (querySnapshot, err) in
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
    
    func deleteArticle(artcleID: String) {
        let challengeRef = database.collection("articles")
        challengeRef.document(artcleID).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func deleteComment(articleID: String, commentID: String) {
        let challengeRef = database.collection("articles").document(articleID).collection("comments")
        challengeRef.document(commentID).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        
    }
    
    func fetchArticle(articleID: String, completion: @escaping (Result<Article, Error>) -> Void) {
        
        let queryCollection = database.collection("articles")
        queryCollection.whereField("id", isEqualTo: articleID)
            .getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                var deeplinkArticle: Article?
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let article = try document.data(as: Article.self, decoder: Firestore.Decoder()) {
                            deeplinkArticle = article
                        }
                        
                    } catch {
                        print(error)
                    }
                }
                if let deeplinkArticle = deeplinkArticle {
                    completion(.success(deeplinkArticle))
                }
            }
            
        }
        
    }
    
}
