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
    
    func fetchRecord(date: Date, completion: @escaping (Result<Record?, Error>) -> Void) {
        
        var calendar = Calendar.current
        if let timeZone = TimeZone(identifier: "Asia/Taipei") {
            calendar.timeZone = timeZone
        }

        let startDateComponents: DateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        var endDateComponents = DateComponents()
        endDateComponents.day = 1
        endDateComponents.second = -1
        
        guard let startDate = calendar.date(from: startDateComponents),
              let endDate = calendar.date(byAdding: endDateComponents, to: startDate) else { return }

        print(startDate)
        print(endDate)
        
        let queryCollection = database.collection("user").document("Aimee").collection("record")
        
        queryCollection
            .whereField("date", isGreaterThanOrEqualTo: startDate)
            .whereField("date", isLessThan: endDate)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    guard let documents = querySnapshot?.documents else { return }
                    if documents.count == 0 {
                        completion(.success(nil))
                    }
                    for document in documents {
                        
                        do {
                            if let record = try document.data(as: Record.self, decoder: Firestore.Decoder()) {
                                completion(.success(record))
                            }
                            
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
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
