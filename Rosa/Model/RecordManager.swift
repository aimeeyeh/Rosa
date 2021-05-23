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
    
    func fetchRecord(date: Date, completion: @escaping (Result<Record, Error>) -> Void) {
        
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)
        
        let queryCollection = database.collection("user").document("Aimee").collection("record")
        
        queryCollection
            .whereField("date", isGreaterThan: start )
            .whereField("date", isLessThan: end!)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    var fetchedRecord: Record?
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            if let record = try document.data(as: Record.self, decoder: Firestore.Decoder()) {
                                fetchedRecord = record
                            }
                            
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    
                    completion(.success(fetchedRecord!))
                }
            }
    }

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
