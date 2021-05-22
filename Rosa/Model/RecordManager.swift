//
//  RecordManager.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/21.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class RecordManager {
    
    static let shared = RecordManager()
    
    lazy var database = Firestore.firestore()
    
    func postDailyRecord(record: inout Record, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = database.collection("user").document("Aimee").collection("record").document()
        // 需要先有Aimee這個user
        
        record.id = document.documentID

        do {
            try document.setData(from: record)
            print("Record Update Success")
        } catch let error {
            print("Error writing record to Firestore: \(error)")
        }
        
    }
    
}
