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
    
    func fetchAllRecords(completion: @escaping (Result<[Record], Error>) -> Void) {
        
        guard let userID = UserManager.shared.currentUser?.id else { return }
        
        let queryCollection = database.collection("user").document("\(userID)").collection("record")
        
        queryCollection.addSnapshotListener { (querySnapshot, err) in
            
            if let err = err {
                
                print("Error getting documents: \(err)")
                
            } else {
                
                var records = [Record]()
                
                for document in querySnapshot!.documents {
                    
                    do {
                        if let record = try document.data(as: Record.self, decoder: Firestore.Decoder()) {
                            records.append(record)
                        }
                        
                    } catch {
                        
                        completion(.failure(error))
                    }
                }
                
                completion(.success(records))
            }
        }
        
    }
    
    func fetchRecord(date: Date, completion: @escaping (Result<Record?, Error>) -> Void) {
        
        let calendar = Calendar.current
        
        let startDateComponents: DateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        
        var endDateComponents = DateComponents()
        endDateComponents.day = 1
        endDateComponents.second = -1
        
        guard let userID = UserManager.shared.currentUser?.id,
              let startDate = calendar.date(from: startDateComponents),
              let endDate = calendar.date(byAdding: endDateComponents, to: startDate) else { return }
        
        let queryCollection = database.collection("user").document("\(userID)").collection("record")
        
        queryCollection
            .whereField("date", isGreaterThanOrEqualTo: startDate)
            .whereField("date", isLessThan: endDate)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    
                } else {
                    
                    guard let documents = querySnapshot?.documents else { return }
                    
                    if documents.isEmpty {
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
    
    func postDailyRecord(record: inout Record, selectedDate: Date,
                         completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let userID = UserManager.shared.currentUser?.id else { return }
        
        let recordRef = database.collection("user").document("\(userID)").collection("record")
        
        let document = recordRef.document()
        
        let calendar = Calendar.current
        
        let todayStartTime = calendar.startOfDay(for: selectedDate)
        
        record.id = document.documentID
        record.date = todayStartTime
        
        do {
            try document.setData(from: record)
            print("Record Update Success")
            
        } catch {
            
            print("Error writing record to Firestore: \(error)")
        }
        
    }
    
    func fetchPast7daysRecords(completion: @escaping (Result<[Record], Error>) -> Void) {
        
        let today = Date()
        let calendar = Calendar.current
        let todayStartTime = calendar.startOfDay(for: today)
        
        var endDateComponents = DateComponents()
        endDateComponents.day = -6
        
        guard let userID = UserManager.shared.currentUser?.id,
              let sevenDaysAgo = calendar.date(byAdding: endDateComponents, to: todayStartTime) else { return }
        
        let queryCollection = database.collection("user").document("\(userID)").collection("record")
        
        queryCollection
            .whereField("date", isGreaterThanOrEqualTo: sevenDaysAgo )
            .whereField("date", isLessThanOrEqualTo: todayStartTime)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    
                } else {
                    
                    var records = [Record]()
                    
                    guard let documents = querySnapshot?.documents else { return }
                    
                    if documents.isEmpty {
                        completion(.success([])) 
                    }
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            if let record = try document.data(as: Record.self, decoder: Firestore.Decoder()) {
                                records.append(record)
                            }
                            
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    completion(.success(records))
                }
            }
    }
    
    func deleteRecord(recordID: String) {
        
        guard let userID = UserManager.shared.currentUser?.id else { return }
        
        let recordRef = database.collection("user").document(userID).collection("record")
        
        recordRef.document(recordID).delete { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
}
