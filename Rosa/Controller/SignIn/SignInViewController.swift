//
//  SignInViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/28.
//

import UIKit
import AuthenticationServices
import Lottie
import CryptoKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    @IBOutlet weak var signinButton: UIButton!
    @IBOutlet weak var lottieView: AnimationView!
    @IBOutlet weak var privacyButton: UIButton!
    
    var defaultName = "Anonymous"
    
    let appleButton = ASAuthorizationAppleIDButton()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setupAppleButton()
        setUpPrivacyConstraints()
        setupLottie()
    }
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        
        precondition(length > 0)
        let charset: [Character] =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
    
    func setupAppleButton() {
        
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(didTapAppleButton), for: .touchUpInside)
        view.addSubview(appleButton)
        NSLayoutConstraint.activate([
            appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 180),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            appleButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func setupLottie() {
        
        let animationView = Animation.named("Lottie_girlWithFlowers")
        lottieView.animation = animationView
        lottieView.animationSpeed = 0.8
        lottieView.play()
        lottieView.loopMode = .loop
        lottieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lottieView.topAnchor.constraint(equalTo: view.topAnchor, constant: 130)
        ])
    }
    
    func setUpPrivacyConstraints() {
        privacyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            privacyButton.topAnchor.constraint(equalTo: appleButton.bottomAnchor, constant: 30),
            privacyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc
    @available(iOS 13, *)
    func didTapAppleButton() {
        
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        
        // add in things depend on what the app needs
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    @IBAction func skipSignIn(_ sender: Any) {

        signinButton.isEnabled = false
        let defaults = UserDefaults.standard
        defaults.set("Aimee", forKey: "userID")
        
        UserManager.shared.checkIsExistingUser(userName: "secretAimee") { result in
            
            switch result {
            
            case .success(let user):
                
                self.performSegue(withIdentifier: "showHomePage", sender: user)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }

    }
}

@available(iOS 13.0, *)
extension SignInViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
     
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }

            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }

            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            if let defaultName = appleIDCredential.fullName?.givenName {
                self.defaultName = defaultName
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    return
                } else {
                    guard let user = authResult?.user else { return }

                    let defaults = UserDefaults.standard
                                        
//                    print("\(String(describing: user.displayName))")

                    guard let uid = Auth.auth().currentUser?.uid else { return }
                    defaults.set(uid, forKey: "userID")

                    UserManager.shared.checkIsExistingUser(userName: user.displayName ?? self.defaultName) { result in
                        
                        switch result {
                        
                        case .success(let user):
                            
                            self.performSegue(withIdentifier: "showHomePage", sender: user)
                            
                        case .failure(let error):
                            
                            print("fetchData.failure: \(error)")
                        }
                    }

//                    self.performSegue(withIdentifier: "showHomePage", sender: user)

                }
                // User is signed in to Firebase with Apple.
                // ...
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
}
