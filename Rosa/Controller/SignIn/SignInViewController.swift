//
//  SignInViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/28.
//

import UIKit
import AuthenticationServices

class SignInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    func setupView() {
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            appleButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc
    func didTapAppleButton() {
        if #available(iOS 13.0, *) {
            let provider = ASAuthorizationAppleIDProvider()
            let request = provider.createRequest()
            
            // add in things depend on what the app needs
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
    }
    
    @IBAction func skipSignIn(_ sender: Any) {
        performSegue(withIdentifier: "showHomePage", sender: nil)
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        switch authorization.credential {
        
        case let credentials as ASAuthorizationAppleIDCredential:
            let user = User(credentials: credentials)
            
            let defaults = UserDefaults.standard
            defaults.set(user.name, forKey: "userName")
            defaults.set(user.id, forKey: "userID")
            
            UserManager.shared.addNewUser()
            
            print("""
            ID: \(user.id),
            Name: \(user.name),
            Email: \(user.email)
            """)
            
            performSegue(withIdentifier: "showHomePage", sender: user)
            
        default: break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign In Error: \(error)")
    }
    
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
        
}
