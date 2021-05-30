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
    let defaultID = "Aimee"
    
    func addNewUser() {
        
//        database.collection("user").document(userID).set(new HashMap<String, Object>())
        database.collection("user").document(userID ?? defaultID).setData(["userName": userName ?? defaultID]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
