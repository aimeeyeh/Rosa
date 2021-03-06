//
//  ChallengeManager.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/21.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChallengeManager {
    
    static let shared = ChallengeManager()
    
    lazy var database = Firestore.firestore()
    
    var defaultChallenges = DefaultChallenge.challenges
    
    var currentProgress: Int = 0
    
    // MARK: - fetch challenge for each date
    
    func fetchChallenge(date: Date, completion: @escaping (Result<[Challenge], Error>) -> Void) {
        
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)
        
        guard let userID = UserManager.shared.currentUser?.id else { return }
        
        let queryCollection = database.collection("user").document("\(userID)").collection("challenge")
        
        queryCollection
            .whereField("setUpDate", isGreaterThanOrEqualTo: start )
            .whereField("setUpDate", isLessThan: end!)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    
                } else {
                    
                    var challenges = [Challenge]()
                    
                    for document in querySnapshot!.documents {
                        
                        do {
                            if let challenge = try document.data(as: Challenge.self, decoder: Firestore.Decoder()) {
                                challenges.append(challenge)
                            }
                            
                        } catch {
                            
                            completion(.failure(error))
                        }
                    }
                    
                    completion(.success(challenges))
                }
            }
    }
    
    // MARK: - add selected challenge to the following 30 days
    
    func postChallenge(challenge: inout Challenge, completion: @escaping (Result<String, Error>) -> Void) {
        
        let today = Date()
        let calendar = Calendar.current
        let todayStartTime = calendar.startOfDay(for: today)
        
        var thirtyDays = [todayStartTime]
        
        func setUp30Days(date: Date) {
            var dayComponent = DateComponents()
            dayComponent.day = 1
            let theCalendar = Calendar.current
            let nextDate = theCalendar.date(byAdding: dayComponent, to: date)
            thirtyDays.append(nextDate!)
        }
        
        for _ in 0...29 {
            let endIndex = thirtyDays.count - 1
            setUp30Days(date: thirtyDays[endIndex])
        }
        
        guard let userID = UserManager.shared.currentUser?.id else { return }
        
        let collection = database.collection("user").document("\(userID)").collection("challenge")
        
        for day in thirtyDays {
            
            let document = collection.document()
            challenge.id = document.documentID
            challenge.setUpDate = day
            
            if day == todayStartTime {
                challenge.isFirstDay = true
            } else {
                challenge.isFirstDay = false
            }
            
            do {
                try document.setData(from: challenge)
                print("Challenge Updated Success")
                
            } catch {
                
                print("Error writing challenge to Firestore: \(error)")
            }
        }
        
    }
    
    // MARK: - update today and tomorrow's challenge progress
    
    func updateChallengeProgress(challenge: inout Challenge,
                                 currentProgress: Int,
                                 currentChallengeTitle: String,
                                 onChallengeCompleted: @escaping () -> Void) {
        
        func updateProgressOfTheDay(date: Date, isToday: Bool = false) {
            
            let calendar = Calendar.current
            
            let start = calendar.startOfDay(for: date)
            
            let end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: start)
            
            guard let userID = UserManager.shared.currentUser?.id else { return }
            
            let challengeRef = database.collection("user").document("\(userID)").collection("challenge")
            
            challengeRef
                .whereField("challengeTitle", isEqualTo: currentChallengeTitle)
                .whereField("setUpDate", isEqualTo: start )
                .whereField("setUpDate", isGreaterThanOrEqualTo: start )
                .whereField("setUpDate", isLessThan: end!)
                .getDocuments { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                        
                    } else {
                        
                        for document in querySnapshot!.documents {
                            
                            self.updateDocumentProgress(documentID: document.documentID) {
                                if isToday {
                                    onChallengeCompleted()
                                }
                            }
                            
                            if isToday {
                                self.updateIsChecked(documentID: document.documentID)
                            }
                        }
                    }
                }
        }
        
        self.currentProgress = currentProgress
        
        let today = Date()
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let theCalendar = Calendar.current
        let tomorrow = theCalendar.date(byAdding: dayComponent, to: today)
        
        updateProgressOfTheDay(date: today, isToday: true)
        updateProgressOfTheDay(date: tomorrow!)
        
    }
    
    func updateDocumentProgress(documentID: String, onChallengeCompleted: () -> Void) {
        
        guard let userID = UserManager.shared.currentUser?.id else { return }
        
        let queryCollection = database.collection("user").document("\(userID)").collection("challenge")
        
        let challengeRef = queryCollection.document("\(documentID)")
        
        let numberAfterAdding = self.currentProgress + 1
        
        if checkChallengeHasCompleted(progress: numberAfterAdding) {
            onChallengeCompleted()
        }
        
        challengeRef.updateData([
            "progress": numberAfterAdding
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document progress has successfully updated")
                
            }
        }
    }
    
    func checkChallengeHasCompleted(progress: Int) -> Bool {
        if progress == 30 {
            print("Challenge Completed!")
            return true
        }
        return false
    }
    
    func updateIsChecked(documentID: String) {
        
        guard let userID = UserManager.shared.currentUser?.id else { return }
        
        let queryCollection = database.collection("user").document("\(userID)").collection("challenge")
        
        let challengeRef = queryCollection.document("\(documentID)")
        
        challengeRef.updateData([
            "isChecked": true
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document property isChecked has successfully updated")
            }
        }
    }
    
    // MARK: - delete 30 day challenges using GCD
    
    func delete30dayChallenges(challengeTitle: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        guard let userID = UserManager.shared.currentUser?.id else { return }
        
        let challengeRef = database.collection("user").document("\(userID)").collection("challenge")
        
        challengeRef
            .whereField("challengeTitle", isEqualTo: challengeTitle)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    completion(.failure(err))
                } else {
                    let dispatchGroup = DispatchGroup()
                    for document in querySnapshot!.documents {
                        dispatchGroup.enter()
                        executeDeleteDocuments(documentID: document.documentID) { _ in
                            dispatchGroup.leave()
                        }
                    }
                    dispatchGroup.notify(queue: .main) {
                        completion(.success("deleted success!"))
                    }
                }
            }
        
        func executeDeleteDocuments(documentID: String, completion: @escaping (Result<String, Error>) -> Void ) {
            
            let challengeRef = database.collection("user").document("\(userID)").collection("challenge")
            
            challengeRef.document(documentID).delete { err in
                if let err = err {
                    print("Error removing document: \(err)")
                    completion(.failure(err))
                } else {
                    print("Document successfully removed!")
                    completion(.success("Document successfully removed!"))
                }
            }
        }
        
    }
    
    // MARK: - default challenges
    
    struct DefaultChallenge {
        
        var backgroundColor: UIColor
        
        var challengeImage: String
        
        var challengeTitle: String
        
        var category: String
        
        static let challenges: [DefaultChallenge] = [
            DefaultChallenge(
                backgroundColor: UIColor.rgb(red: 255, green: 163, blue: 135, alpha: 0.5),
                challengeImage: "glutenFree",
                challengeTitle: "Gluten Free".localized(),
                category: "withdrawal"
            ),
            DefaultChallenge(
                backgroundColor: UIColor.rgb(red: 226, green: 158, blue: 74, alpha: 0.5),
                challengeImage: "dairyFree",
                challengeTitle: "Dairy Free".localized(),
                category: "withdrawal"
            ),
            DefaultChallenge(
                backgroundColor: UIColor.rgb(red: 255, green: 204, blue: 0, alpha: 0.5),
                challengeImage: "junkFoodFree",
                challengeTitle: "Junk Free".localized(),
                category: "withdrawal"
            ),
            DefaultChallenge(
                backgroundColor: UIColor.rgb(red: 255, green: 163, blue: 135, alpha: 0.5),
                challengeImage: "sugarFree",
                challengeTitle: "Sugar Free".localized(),
                category: "withdrawal"
            ),
            DefaultChallenge(
                backgroundColor: UIColor.rgb(red: 137, green: 196, blue: 255, alpha: 0.5),
                challengeImage: "water",
                challengeTitle: "Water".localized(),
                category: "routineCare"
            ),
            DefaultChallenge(
                backgroundColor: UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.5),
                challengeImage: "sleep",
                challengeTitle: "Sleep".localized(),
                category: "routineCare"
            ),
            DefaultChallenge(
                backgroundColor: UIColor.rgb(red: 78, green: 206, blue: 165, alpha: 0.5),
                challengeImage: "hairOil",
                challengeTitle: "Hair Oil".localized(),
                category: "withdrawal"
            ),
            DefaultChallenge(
                backgroundColor: UIColor.rgb(red: 255, green: 104, blue: 132, alpha: 0.5),
                challengeImage: "spicy",
                challengeTitle: "No Spicy".localized(),
                category: "withdrawal"
            ),
            DefaultChallenge(
                backgroundColor: UIColor.rgb(red: 197, green: 153, blue: 255, alpha: 0.5),
                challengeImage: "toothpaste",
                challengeTitle: "Toothpaste".localized(),
                category: "withdrawal"
            ),
            DefaultChallenge(
                backgroundColor: UIColor.rgb(red: 255, green: 193, blue: 218, alpha: 0.5),
                challengeImage: "cushion",
                challengeTitle: "No cushion".localized(),
                category: "withdrawal"
            ),
            DefaultChallenge(
                backgroundColor: UIColor.rgb(red: 255, green: 231, blue: 127, alpha: 0.5),
                challengeImage: "facialMask",
                challengeTitle: "Facial Mask".localized(),
                category: "withdrawal"
            )
        ]
    }
    
}
