//
//  UIStoryboard+Extension.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/17.
//

import UIKit

private struct StoryboardCategory {
    
    static let main = "Main"
    
    static let signIn = "SignIn"
    
    static let calendar = "Calender"
    
    static let record = "Record"
    
    static let articles = "Articles"
    
    static let profile = "Profile"
    
    static let challenge = "Challenge"
}

extension UIStoryboard {
    
    static var main: UIStoryboard { return stStoryboard(name: StoryboardCategory.main) }
    
    static var signIn: UIStoryboard { return stStoryboard(name: StoryboardCategory.signIn) }
    
    static var calendar: UIStoryboard { return stStoryboard(name: StoryboardCategory.calendar) }
    
    static var record: UIStoryboard { return stStoryboard(name: StoryboardCategory.record) }
    
    static var profile: UIStoryboard { return stStoryboard(name: StoryboardCategory.profile) }
    
    static var articles: UIStoryboard { return stStoryboard(name: StoryboardCategory.articles) }
    
    static var challenge: UIStoryboard { return stStoryboard(name: StoryboardCategory.challenge)}
    
    private static func stStoryboard(name: String) -> UIStoryboard {
        
        return UIStoryboard(name: name, bundle: nil)
    }
}
