//
//  PostViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/20.
//

import UIKit
import Kingfisher
import FirebaseStorage
import Lottie
import IQKeyboardManagerSwift

enum ArticlePhotoType {
    case firstImage
    case secondImage
    case thirdImage
    case forthImage
}

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var firstImage: UIImageView!
    @IBOutlet weak var secondImage: UIImageView!
    @IBOutlet weak var thirdImage: UIImageView!
    @IBOutlet weak var forthImage: UIImageView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var forthButton: UIButton!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var lottieView: AnimationView!
    
    var category: String = "酒糟"
    
    var photos: [String] = []
    
    let user = UserManager.shared.currentUser
    
    private let storage = Storage.storage().reference()
    
    var currentPhotoType: ArticlePhotoType?
    
    var firstImageUrl: String = "" {
        didSet {
            photos.append(firstImageUrl)
        }
    }
    var secondImageUrl: String = "" {
        didSet {
            photos.append(secondImageUrl)
        }
    }
    var thirdImageUrl: String = "" {
        didSet {
            photos.append(thirdImageUrl)
        }
    }
    var forthImageUrl: String = "" {
        didSet {
            photos.append(forthImageUrl)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        lottieView.isHidden = true
        showLoadingView()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func fetchUser() {
        UserManager.shared.fetchUser { result in
            
            switch result {
            
            case .success(let user):
                
                print(user)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
        
    }
    
    func showLoadingView() {
        let animationView = Animation.named("bouncingBall")
        lottieView.animation = animationView
        lottieView.animationSpeed = 0.8
        lottieView.play()
        lottieView.loopMode = .loop
    }
    
    func setPhotoUrl(url: String) {
        switch currentPhotoType {
        case .firstImage:
            firstImage.kf.setImage(with: URL(string: url))
            self.firstImageUrl = url
        case .secondImage:
            secondImage.kf.setImage(with: URL(string: url))
            self.secondImageUrl = url
        case .thirdImage:
            thirdImage.kf.setImage(with: URL(string: url))
            self.thirdImageUrl = url
        default:
            forthImage.kf.setImage(with: URL(string: url))
            self.firstImageUrl = url
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        lottieView.isHidden = false
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData() else { return }
        let userID = UserDefaults.standard.string(forKey: "userID")
        let defaultID = "Aimee"
        let imageName = "images/\(userID ?? defaultID)/\(Date()).png"
        let ref = storage.child(imageName)
        ref.putData(imageData, metadata: nil) { [weak self] _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            self?.storage.child(imageName).downloadURL { [weak self] url, error in
                guard let url = url, error == nil else { return }
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                self?.lottieView.isHidden = true
                self?.setPhotoUrl(url: urlString)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        switch currentPhotoType {
        case .firstImage:
            firstButton.tintColor = .lightGray
        case .secondImage:
            secondButton.tintColor = .lightGray
        case .thirdImage:
            thirdButton.tintColor = .lightGray
        default:
            forthButton.tintColor = .lightGray
        }
    }
    
    func showPicker(_ photoType: ArticlePhotoType) {
        self.currentPhotoType = photoType
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        self.present(picker, animated: true)
        
    }
    
    @IBAction func backToPreviousPage(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadFirstImage(_ sender: Any) {
        showPicker(ArticlePhotoType.firstImage)
        firstButton.tintColor = .clear
    }
    
    @IBAction func uploadSecondImage(_ sender: Any) {
        showPicker(ArticlePhotoType.secondImage)
        secondButton.tintColor = .clear
    }
    
    @IBAction func uploadThirdImage(_ sender: Any) {
        showPicker(ArticlePhotoType.thirdImage)
        thirdButton.tintColor = .clear
    }
    
    @IBAction func uploadForthImage(_ sender: Any) {
        showPicker(ArticlePhotoType.forthImage)
        forthButton.tintColor = .clear
    }
    
    @IBAction func onTapSegementedControl(_ sender: UISegmentedControl) {
        
        let index = sender.selectedSegmentIndex
        if let category = sender.titleForSegment(at: index) {
            self.category = category
        }
    }
    
    @IBAction func postArticle(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        
        guard let title = titleTextfield.text else { return }
        
        if photos.isEmpty {
            photos.append("https://firebasestorage.googleapis.com/v0/b/rosa-5438e.appspot.com/" +
                            "o/images%2FAimee%2F2021-06-08%2011:20:40%20%2B0000.png" +
                            "?alt=media&token=eb673f9d-7e4c-48ae-aad7-2e09583c3ff0")
        }
        
        guard let userID = user?.id else { return }
        guard let userName = user?.name else { return }
        guard let userPhoto = user?.photo else { return }
        
        var article = Article(id: "", authorID: userID, authorName: userName, authorPhoto: userPhoto,
                              category: category, content: contentTextView.text, createdTime: Date(),
                              likes: 0, photos: photos, title: title)
        
        ArticleManager.shared.postArticle(article: &article)
    }
    
}
