//
//  EditProfileViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/4.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import Kingfisher

class EditProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let storage = Storage.storage().reference()
    
//    var profilePhotoURL: String? {
//        didSet {
//            guard let url = profilePhotoURL else { return }
//            UserManager.shared.updateUserProfilePhoto(photoURL: url)
//            tableView.reloadData()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadEditProfile()
//        tableView.reloadData()
    }
    
    func reloadEditProfile() {
        UserManager.shared.checkIsExistingUser { result in
            
            switch result {
            
            case .success(let user):
                
//                self.profilePhotoURL = user.photo
                print(user)
                self.tableView.reloadData()
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
            
        }
    }
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        guard let imageData = image.pngData() else {
            return
        }
        
        guard let userID = UserManager.shared.currentUser?.id else { return }
        
        let imageName = "images/\(userID)/\(Date()).png"
        
        let ref = storage.child(imageName)
        
        ref.putData(imageData, metadata: nil) { [weak self] _, error in
            guard error == nil else {
                print("Failed to upload")
                return
            }
            self?.storage.child(imageName).downloadURL { [weak self] url, error in
                guard let url = url, error == nil else {
                    return
                }
                let urlString = url.absoluteString
                print("Download URL: \(urlString)")
                UserManager.shared.updateUserProfilePhoto(photoURL: urlString)
                self?.reloadEditProfile()

            }
            
        }
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditPhotoTableViewCell",
                                                        for: indexPath) as? EditPhotoTableViewCell {
                
                func showPicker() {
                    let picker = UIImagePickerController()
                    picker.sourceType = .photoLibrary
                    picker.delegate = self
                    picker.allowsEditing = true
                    self.present(picker, animated: true)
                    
                }
                cell.onButtonPressed = {
                   showPicker()
                }
                
                if let profilePhotoURL = UserManager.shared.currentUser?.photo {
                    cell.profileImage.kf.setImage(with: URL(string: profilePhotoURL))
                }
                
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditNameTableViewCell",
                                                        for: indexPath) as? EditNameTableViewCell {
                cell.configureName()
                return cell
            }
        default:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "EditBlocklistTableViewCell",
                                                        for: indexPath) as? EditBlocklistTableViewCell {
                return cell
            }
        }
                            
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 180
        default:
            return 55
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            return
        case 1:
            performSegue(withIdentifier: "showEditNameVC", sender: self)
        default:
            performSegue(withIdentifier: "showEditBlocklistVC", sender: self)
        }
    }
    
}
