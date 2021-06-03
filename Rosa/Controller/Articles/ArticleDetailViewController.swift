//
//  ArticleDetailViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/19.
//

import UIKit
import SwiftEntryKit

class ArticleDetailViewController: UIViewController {

    @IBOutlet weak var commentTextfield: UITextField!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorPhoto: UIImageView!
    
    var article: Article = Article(id: "fail",
                                   author: "fail",
                                   category: "fail",
                                   content: "fail",
                                   createdTime: Date(),
                                   likes: 0,
                                   photos: ["fail"],
                                   title: "fail") 
    
    var comments: [Comment] = [Comment(id: "fail",
                                       authorID: "fail",
                                       authorName: "fail",
                                       content: "fail",
                                       date: Date())] {
        didSet {
            filterdDefaultComments = comments.filter { $0.authorID != "default"}
        }
    }
    
    var filterdDefaultComments: [Comment]? {
        didSet {
            filterComments()
        }
    }
    
    var filteredBlockComments: [Comment]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var blockedUsers: [String]? {
        didSet {
            filterComments()
            checkLikeButtonStatus()
        }
    }
    
    func filterComments() {
        guard let blockedUsers = self.blockedUsers else { return }
        filteredBlockComments = filterdDefaultComments?.filter { !blockedUsers.contains($0.authorID)}
    }
    
    func fetchBlocklist() {
        if let currentUser = UserManager.shared.currentUser {
            blockedUsers = currentUser.blocklist
        }
    }
    
    var toBeBlockedUserID: String?

    override func viewDidLoad() {

        super.viewDidLoad()
        authorName.text = article.author
        configureTextfield()
        fetchComments(articleID: article.id)
        tableView.allowsSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.tabBarController?.tabBar.isHidden = true
        reloadComments()
//        checkLikeButtonStatus()

    }
    
    override func viewWillDisappear(_ animated: Bool) {

        self.tabBarController?.tabBar.isHidden = false

    }
    
    func reloadComments() {
        UserManager.shared.checkIsExistingUser { result in
            
            switch result {
            
            case .success(let user):
                
                self.fetchBlocklist()
                print(user)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }

    }
    
    func checkLikeButtonStatus() {
        
        let articleID = article.id
        guard let currentUser = UserManager.shared.currentUser else { return }
        if let likedArticles = currentUser.likedArticles {
            if likedArticles.contains(articleID) {
                likeButton.isSelected = true
            } else {
                likeButton.isSelected = false
            }
        }
    }
    
    var displayMode = EKAttributes.DisplayMode.inferred
    
    func setupAttributes() -> EKAttributes {
        var attributes = EKAttributes.centerFloat
        attributes.displayMode = displayMode
        attributes.windowLevel = .alerts
        attributes.displayDuration = .infinity
        attributes.hapticFeedbackType = .success
        attributes.screenInteraction = .absorbTouches
        attributes.entryInteraction = .absorbTouches
        attributes.scroll = .disabled
        attributes.screenBackground = .color(color: .init(light: UIColor(white: 100.0/255.0, alpha: 0.3),
                                                          dark: UIColor(white: 50.0/255.0, alpha: 0.3)))
        attributes.entryBackground = .color(color: .white)
        attributes.entranceAnimation = .init(
            scale: .init(
                from: 0.9,
                to: 1,
                duration: 0.4,
                spring: .init(damping: 1, initialVelocity: 0)
            ),
            fade: .init(
                from: 0,
                to: 1,
                duration: 0.3
            )
        )
        attributes.exitAnimation = .init(
            fade: .init(
                from: 1,
                to: 0,
                duration: 0.2
            )
        )
        attributes.shadow = .active(
            with: .init(
                color: .black,
                opacity: 0.3,
                radius: 5
            )
        )
        return attributes
    }
    
    func showAlertView(attributes: EKAttributes) {
        let title = EKProperty.LabelContent(
            text: "Hopa!",
            style: .init(
                font: MainFont.medium.with(size: 15),
                color: .black,
                alignment: .center,
                displayMode: displayMode
            )
        )
        
        let text =
        """
        Are you sure you want to block this user?
        """
        let description = EKProperty.LabelContent(
            text: text,
            style: .init(
                font: MainFont.light.with(size: 13),
                color: .black,
                alignment: .center,
                displayMode: displayMode
            )
        )
        let image = EKProperty.ImageContent(
            imageName: "rosa",
            displayMode: displayMode,
            size: CGSize(width: 60, height: 60),
            contentMode: .scaleAspectFit
        )
        let simpleMessage = EKSimpleMessage(
            image: image,
            title: title,
            description: description
        )
        let buttonFont = MainFont.medium.with(size: 16)
        let closeButtonLabelStyle = EKProperty.LabelStyle(
            font: buttonFont,
            color: Color.Gray.a800,
            displayMode: displayMode
        )
        let closeButtonLabel = EKProperty.LabelContent(
            text: "NOT NOW",
            style: closeButtonLabelStyle
        )
        let closeButton = EKProperty.ButtonContent(
            label: closeButtonLabel,
            backgroundColor: .clear,
            highlightedBackgroundColor: Color.Gray.a800.with(alpha: 0.05),
            displayMode: displayMode) {
                SwiftEntryKit.dismiss()
        }

        let blockButtonLabelStyle = EKProperty.LabelStyle(
            font: buttonFont,
            color: Color.Teal.a600,
            displayMode: displayMode
        )
        let blockButtonLabel = EKProperty.LabelContent(
            text: "BLOCK",
            style: blockButtonLabelStyle
        )
        let blockButton = EKProperty.ButtonContent(
            label: blockButtonLabel,
            backgroundColor: .clear,
            highlightedBackgroundColor: Color.Teal.a600.with(alpha: 0.05),
            displayMode: displayMode) {
            SwiftEntryKit.dismiss()
            
            guard let toBeBlockedUserID = self.toBeBlockedUserID else { return }
            UserManager.shared.blockUser(toBeBlockUserID: toBeBlockedUserID)
            
            self.reloadComments()
        }
        
        // Generate the content
        let buttonsBarContent = EKProperty.ButtonBarContent(
            with: blockButton, closeButton,
            separatorColor: Color.Gray.light,
            displayMode: displayMode,
            expandAnimatedly: true
        )
        let alertMessage = EKAlertMessage(
            simpleMessage: simpleMessage,
            buttonBarContent: buttonsBarContent
        )
        let contentView = EKAlertMessageView(with: alertMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    @IBAction func backToArticle(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)

    }
    
    func configureTextfield() {
        
        commentTextfield.layer.cornerRadius = 21
        commentTextfield.clipsToBounds = true
        
    }

    @IBAction func editingDidEnd(_ sender: UITextField) {
        if let text = sender.text {
            ArticleManager.shared.postComment(documentID: article.id, comment: text)
        }
        commentTextfield.text = ""
    }
    
    @IBAction func likedArticle(_ sender: UIButton) {
        let articleID = article.id
        let currentLikes = article.likes
        if sender.isSelected {
            ArticleManager.shared.unLikeArticles(articleID: articleID, currentLikes: currentLikes)
        } else {
            ArticleManager.shared.likeArticles(articleID: articleID, currentLikes: currentLikes)
        }
        
        likeButton.isSelected = !likeButton.isSelected
        
    }
    
    func fetchComments(articleID: String) {
        ArticleManager.shared.fetchComments(articleID: articleID) { [weak self] result in
            
            switch result {
            
            case .success(let comments):
                
                self?.comments = comments
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
    }
    
}

extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let filteredBlockComments = self.filteredBlockComments else { return 3 }
        
        if filteredBlockComments.count == 0 {
            return 3
        } else {
            return filteredBlockComments.count+2
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell",
                                                        for: indexPath) as? PhotoCell {
                cell.configureScrollView(article: article)
                cell.configurePageControl(article: article)
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell",
                                                        for: indexPath) as? ContentCell {
                
                cell.configureContent(article: article)
                return cell
            }
            
        default:
            if comments.count == 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "NoCommentCell",
                                                            for: indexPath) as? NoCommentCell {
                    
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell",
                                                            for: indexPath) as? CommentCell {
                    if let comments = filteredBlockComments {
                        cell.configureCommentCell(comment: comments[indexPath.row-2])
                    }
                    return cell
                }
            }

        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 500
        case 1:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if comments.count > 1 {
            switch indexPath.row {
            case 0:
                return
            case 1:
                return
            default:
                self.showAlertView(attributes: setupAttributes())
                if let comments = filteredBlockComments {
                    self.toBeBlockedUserID = comments[indexPath.row-2].authorID
                }
                
            }
            
        }
    }
    
}
