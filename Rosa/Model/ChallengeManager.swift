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
    
    func postChallenge(challenge: inout Challenge, completion: @escaping (Result<String, Error>) -> Void) {
        
        let document = database.collection("user").document("Aimee").collection("challenge").document()
        challenge.id = document.documentID
        challenge.setUpDate = NSDate().timeIntervalSince1970
        challenge.progress = 0

        do {
            try document.setData(from: challenge)
            print("Challenge Updated Success")
        } catch let error {
            print("Error writing challenge to Firestore: \(error)")
        }

    }
    
}

struct DefaultChallenge {

    var backgroundColor: UIColor
    var challengeImage: String
    var challengeTitle: String
    var category: String
    
    static let challenges: [DefaultChallenge] = [
        DefaultChallenge(
            backgroundColor: UIColor.rgb(red: 255, green: 163, blue: 135, alpha: 0.5),
            challengeImage: "glutenFree",
            challengeTitle: "Gluten Free",
            category: "withdrawal"
        ),
        DefaultChallenge(
            backgroundColor: UIColor.rgb(red: 226, green: 158, blue: 74, alpha: 0.5),
            challengeImage: "dairyFree",
            challengeTitle: "Dairy Free",
            category: "withdrawal"
        ),
        DefaultChallenge(
            backgroundColor: UIColor.rgb(red: 255, green: 204, blue: 0, alpha: 0.5),
            challengeImage: "junkFoodFree",
            challengeTitle: "Junk Free",
            category: "withdrawal"
        ),
        DefaultChallenge(
            backgroundColor: UIColor.rgb(red: 255, green: 255, blue: 255, alpha: 0.5),
            challengeImage: "sugarFree",
            challengeTitle: "Sugar Free",
            category: "withdrawal"
        ),
        DefaultChallenge(
            backgroundColor: UIColor.rgb(red: 137, green: 196, blue: 255, alpha: 0.5),
            challengeImage: "water",
            challengeTitle: "Water",
            category: "routineCare"
        ),
        DefaultChallenge(
            backgroundColor: UIColor.rgb(red: 0, green: 0, blue: 0, alpha: 0.5),
            challengeImage: "sleep",
            challengeTitle: "Sleep",
            category: "routineCare"
        ),
        DefaultChallenge(
            backgroundColor: UIColor.rgb(red: 78, green: 206, blue: 165, alpha: 0.5),
            challengeImage: "hairOil",
            challengeTitle: "Hair Oil",
            category: "withdrawal"
        ),
        DefaultChallenge(
            backgroundColor: UIColor.rgb(red: 255, green: 104, blue: 132, alpha: 0.5),
            challengeImage: "spicy",
            challengeTitle: "No Spicy",
            category: "withdrawal"
        ),
        DefaultChallenge(
            backgroundColor: UIColor.rgb(red: 197, green: 153, blue: 255, alpha: 0.5),
            challengeImage: "toothpaste",
            challengeTitle: "Toothpaste",
            category: "withdrawal"
        ),
        DefaultChallenge(
            backgroundColor: UIColor.rgb(red: 255, green: 193, blue: 218, alpha: 0.5),
            challengeImage: "cusion",
            challengeTitle: "No cusion",
            category: "withdrawal"
        ),
        DefaultChallenge(
            backgroundColor: UIColor.rgb(red: 255, green: 231, blue: 127, alpha: 0.5),
            challengeImage: "facialMask",
            challengeTitle: "Facial Mask",
            category: "withdrawal"
        )
                
    ]

}
