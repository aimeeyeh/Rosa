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
    
    let userID = UserDefaults.standard.string(forKey: "userID")
    let userName = UserDefaults.standard.string(forKey: "userName")
    
    func addNewUser() {
        guard let userID = userID else { return }
        database.collection("user").document(userID).setData(["id": userID, "name": userName ?? "No name"]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
    
    func blockUser(toBeBlockUserID: String) {
        
        let userID = UserDefaults.standard.string(forKey: "userID")
        guard let userID = userID else { return }
        
        let document = database.collection("user").document(userID)

        document.updateData([
                "blocklist": FieldValue.arrayUnion([toBeBlockUserID])
            ])
    }
    
    func fetchBlockedUsers(completion: @escaping (Result<[String], Error>) -> Void) {
        
        let userID = UserDefaults.standard.string(forKey: "userID")
        guard let userID = userID else { return }
        
        let queryCollection = database.collection("user")
        let currentUserDocument = queryCollection.whereField("id", isEqualTo: userID)
        currentUserDocument.getDocuments() { (querySnapshot, err) in
                   if let err = err {
                       print("Error getting documents: \(err)")
                   } else {
                    
                    var blocklistIDs = [String]()
    
                    for document in querySnapshot!.documents {
                        
                        do {
                            if let currentUser = try document.data(as: User.self, decoder: Firestore.Decoder()) {
                                blocklistIDs = currentUser.blocklist ?? []
                            }
                            
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    completion(.success(blocklistIDs))
                }
           }

    }
    
}
