//
//  UserManager.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserManager {
    
    static let shared = UserManager()
    
    lazy var database = Firestore.firestore()
    
    var currentUser: User?
    
    let userID = UserDefaults.standard.string(forKey: "userID") ?? ""
    
    func checkIsExistingUser(userName: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        let queryCollection = database.collection("user")
        
        let currentUserDocument = queryCollection.whereField("id", isEqualTo: userID)
        
        currentUserDocument.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                // new user
                if querySnapshot!.documents.count == 0 {
                    
                    self.currentUser = User(id: self.userID, name: userName )
                    
                    let queryCollection = self.database.collection("user")
                    
                    
                    let defaultPhoto = "https://firebasestorage.googleapis.com/v0/b/rosa-5438e.appspot.com" +
                        "/o/images%2FAimee%2F2021-06-08%2011:20:40%20%2B0000.png?" +
                        "alt=media&token=eb673f9d-7e4c-48ae-aad7-2e09583c3ff0"
                    
                    queryCollection.document(self.userID).setData(["id": self.userID,
                                                                   "name": userName,
                                                                   "photo": defaultPhoto]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                            completion(.failure(err))
                        } else {
                            print("Document successfully written!")
                            if let currentUser = self.currentUser {
                                completion(.success(currentUser))
                            }
                        }
                    }
                    
                } else {
                    
                    // existed user
                    for document in querySnapshot!.documents {
                        
                        do {
                            if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                self.currentUser = user
                            }
                            
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    
                    if let currentUser = self.currentUser {
                        completion(.success(currentUser))
                    }
                }
            }
        }
        
    }
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        
        let queryCollection = database.collection("user")
        
        let currentUserDocument = queryCollection.whereField("id", isEqualTo: userID)
        
        currentUserDocument.getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                            self.currentUser = user
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                if let currentUser = self.currentUser {
                    completion(.success(currentUser))
                }
            }
        }
    }
    
    func blockUser(toBeBlockUserID: String) {
        
        let document = database.collection("user").document(userID)
        
        document.updateData([
            "blocklist": FieldValue.arrayUnion([toBeBlockUserID])
        ])
    }
    
    func updateUserProfilePhoto(photoURL: String) {
        
        let currentUserDocument = database.collection("user").document(userID)
        
        currentUserDocument.updateData([
            "photo": photoURL
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Photo successfully updated")
            }
        }
    }
    
    func updateUserName(name: String) {
        
        let currentUserDocument = database.collection("user").document(userID)
        
        currentUserDocument.updateData([
            "name": name
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Name successfully updated")
            }
        }
    }
    
    func fetchBlocklistUserData(blocklist: [String], completion: @escaping (Result<[User], Error>) -> Void) {
        
        let queryCollection = database.collection("user")
        
        queryCollection.whereField("id", in: blocklist)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    var users = [User]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                users.append(user)
                            }
                            
                        } catch {
                            completion(.failure(error))
                        }
                    }
                    completion(.success(users))
                }
            }
    }
    
    func removeFromBlocklist(blocklistUserID: String) {
        
        let document = database.collection("user").document(userID)
        
        document.updateData([
            "blocklist": FieldValue.arrayRemove([blocklistUserID])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Blocklist successfully updated")
            }
        }
    }
    
    func fetchAuthorPhoto(authorID: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        let queryCollection = database.collection("user")
        
        queryCollection.whereField("id", isEqualTo: authorID)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    var userData: User?
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            if let user = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                userData = user
                            }
                            
                        } catch {
                            completion(.failure(error))
                        }
                    }
                    if let user = userData {
                        completion(.success(user))
                    }
                }
            }
    }
    
}
