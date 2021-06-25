//
//  ArticleDetailViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/19.
//

import UIKit
import SwiftEntryKit
import IQKeyboardManagerSwift

enum AlertType {
    case block
    case delete
}

class ArticleDetailViewController: UIViewController {
    
    @IBOutlet weak var commentTextfield: UITextField!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var authorName: UILabel!
    @IBOutlet weak var authorPhoto: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var moreInfoButton: UIButton!
    
    let currentUser = UserManager.shared.currentUser
    
    var article: Article = Article(id: "fail", authorID: "fail", authorName: "fail", authorPhoto: "fail",
                                   category: "fail", content: "fail", createdTime: Date(), likes: 0,
                                   photos: ["fail"], title: "fail")
    
    var comments: [Comment] = [Comment(id: "fail", authorID: "fail", authorName: "fail", authorPhoto: "fail",
                                       content: "fail", date: Date())] {
        didSet {
            filterdDefaultComments = comments.filter { $0.authorID != "default"}
        }
    }
    
    var filterdDefaultComments: [Comment]? {
        didSet {
            filterComments() // 跟blocked user didset裡的filterComments()是否留一個就夠？
        }
    }
    
    var filteredBlockComments: [Comment]? {
        didSet {
            guard let filteredBlockComments = filteredBlockComments else { return }
            myComments = filteredBlockComments.filter {$0.authorID == currentUser?.id}
            tableView.reloadData()
        }
    }
    
    var myComments: [Comment] = [] {
        didSet {
            for comment in myComments {
                guard let index = filteredBlockComments?.firstIndex(of: comment) else { return }
                indexPathOfMyComments.append(index)
            }
        }
    }
    
    var indexPathOfMyComments: [Int] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    var blockedUsers: [String] = [] {
        didSet {
            filterComments()
            checkLikeButtonStatus()
        }
    }
    
    func filterComments() {
        filteredBlockComments = filterdDefaultComments?.filter { !blockedUsers.contains($0.authorID)}
    }
    
    func fetchBlocklist() {
        if let currentUser = UserManager.shared.currentUser {
            blockedUsers = currentUser.blocklist ?? []
        }
    }
    
    var toBeBlockedUserID: String?
    
    var toBeDeleteCommentID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextfield()
        fetchComments(articleID: article.id)
        checkFollowButtonStatus()
        configureFollowButton()
        tableView.allowsSelection = true
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressSelector))
        tableView.addGestureRecognizer(longPress)
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isHidden = true
        reloadComments()
        configureUpperView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Long Press Gesture
    
    @objc func longPressSelector(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            guard let indexPath = tableView.indexPathForRow(at: touchPoint) else { return }
            if comments.count > 1 {
                if indexPathOfMyComments.contains(indexPath.row-2) {
                    self.showAlertView(type: .delete, attributes: setupAttributes())
                    guard let comments = filteredBlockComments else { return }
                    self.toBeDeleteCommentID = comments[indexPath.row-2].id
                } else if indexPath.row == 0 || indexPath.row == 1 {
                    return
                } else {
                    self.showAlertView(type: .block, attributes: setupAttributes())
                    guard let comments = filteredBlockComments else { return }
                    self.toBeBlockedUserID = comments[indexPath.row-2].authorID
                }
            }
        }
    }
    
    // MARK: - Model related functions
    
    func reloadComments() {
        UserManager.shared.fetchUser { result in
            
            switch result {
            
            case .success(let user):
                
                self.fetchBlocklist()
                print(user)
                
            case .failure(let error):
                
                print("fetchData.failure: \(error)")
            }
        }
        
    }
    
    func configureUpperView() {
        authorName.text = article.authorName
        authorPhoto.kf.setImage(with: URL(string: article.authorPhoto))
        guard let currentUser = UserManager.shared.currentUser else { return }
        if currentUser.id == article.authorID {
            shareButton.isHidden = true
            moreInfoButton.isHidden = false
        } else {
            shareButton.isHidden = false
            moreInfoButton.isHidden = true
        }
    }
    
    func checkLikeButtonStatus() {
        let articleID = article.id
        guard let currentUser = UserManager.shared.currentUser,
              let likedArticles = currentUser.likedArticles else { return }
        if likedArticles.contains(articleID) {
            likeButton.isSelected = true
        } else {
            likeButton.isSelected = false
        }
    }
    
    func checkFollowButtonStatus() {
        let articleAuthorID = article.authorID
        guard let currentUser = UserManager.shared.currentUser,
              let followed = currentUser.followed else { return }
        
        if followed.contains(articleAuthorID) {
            followButton.isSelected = true
        } else {
            followButton.isSelected = false
        }
    }
    
    func showActionSheet() {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelActionButton = UIAlertAction(title: "Cancel".localized(), style: .cancel) {_ in print("cancel")}
        actionSheetController.addAction(cancelActionButton)
        let deleteActionButton = UIAlertAction(title: "Delete".localized(), style: .destructive) {_ in
            ArticleManager.shared.deleteArticle(artcleID: self.article.id)
            self.navigationController?.popViewController(animated: true)
        }
        let saveActionButton = UIAlertAction(title: "Share", style: .default) {_ in
            guard let userName = UserManager.shared.currentUser?.name else { return }
            let text = "你的朋友 ".localized() + String(userName) + " 剛跟你分享了一篇文章: ".localized()
                + String(self.article.title) + "."
            let image = UIImage(named: "Rosa")
            let myWebsite = NSURL(string: "rosa://?\(self.article.id)")
            let shareAll = [text, image as Any, myWebsite as Any] as [Any]
            let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
        }
        actionSheetController.addAction(deleteActionButton)
        actionSheetController.addAction(saveActionButton)
        actionSheetController.view.tintColor = .darkGray
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: - SwiftEntryKit Setups
    
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
        attributes.screenBackground = .color(
            color: .init(light: UIColor(white: 100.0/255.0, alpha: 0.3), dark: UIColor(white: 50.0/255.0, alpha: 0.3)))
        attributes.entryBackground = .color(color: .white)
        attributes.entranceAnimation = .init(
            scale: .init(from: 0.9, to: 1, duration: 0.4, spring: .init(damping: 1, initialVelocity: 0)),
            fade: .init(from: 0, to: 1, duration: 0.3))
        attributes.exitAnimation = .init(fade: .init(from: 1, to: 0, duration: 0.2))
        attributes.shadow = .active(with: .init(color: .black, opacity: 0.3, radius: 5))
        return attributes
    }
    
    func setUpAlertTitleSection(type: AlertType) -> EKSimpleMessage {
        let title = EKProperty.LabelContent(
            text: "Hopa!",
            style: .init(
                font: MainFont.medium.with(size: 15), color: .black, alignment: .center, displayMode: displayMode
            )
        )
        
        var text = ""
        if type == .block {
            text = "Are you sure you want to block this user?".localized()
        } else {
            text = "Are you sure you want to delete this comment?".localized()
        }
        
        let description = EKProperty.LabelContent(
            text: text,
            style: .init(
                font: MainFont.light.with(size: 13), color: .black, alignment: .center, displayMode: displayMode
            )
        )
        
        var image = EKProperty.ImageContent(
            imageName: "block", displayMode: displayMode,
            size: CGSize(width: 60, height: 60), contentMode: .scaleAspectFit
        )
        
        if type == .delete {
            image = EKProperty.ImageContent(
                imageName: "delete", displayMode: displayMode,
                size: CGSize(width: 60, height: 60), contentMode: .scaleAspectFit
            )
        }
        
        let simpleMessage = EKSimpleMessage(image: image, title: title, description: description)
        
        return simpleMessage
    }
    
    func setUpAlertButtons(type: AlertType) -> EKProperty.ButtonBarContent {
        
        // Cancel Button
        let buttonFont = MainFont.medium.with(size: 16)
        
        let closeButtonLabelStyle = EKProperty.LabelStyle(
            font: buttonFont, color: Color.Gray.a800, displayMode: displayMode
        )
        
        let closeButtonLabel = EKProperty.LabelContent(text: "NOT NOW".localized(), style: closeButtonLabelStyle)
        
        let closeButton = EKProperty.ButtonContent(
            label: closeButtonLabel, backgroundColor: .clear,
            highlightedBackgroundColor: Color.Gray.a800.with(alpha: 0.05), displayMode: displayMode) {
            SwiftEntryKit.dismiss()
        }
        
        // Block Button
        let blockButtonLabelStyle = EKProperty.LabelStyle(
            font: buttonFont, color: Color.Teal.a600, displayMode: displayMode
        )
        
        let blockButtonLabel = EKProperty.LabelContent(
            text: "BLOCK".localized(), style: blockButtonLabelStyle
        )
        
        let blockButton = EKProperty.ButtonContent(
            label: blockButtonLabel, backgroundColor: .clear,
            highlightedBackgroundColor: Color.Teal.a600.with(alpha: 0.05), displayMode: displayMode) {
            SwiftEntryKit.dismiss()
            guard let toBeBlockedUserID = self.toBeBlockedUserID else { return }
            UserManager.shared.blockUser(toBeBlockUserID: toBeBlockedUserID)
            self.reloadComments()
        }
        
        // Delete Button
        let deleteButtonLabelStyle = EKProperty.LabelStyle(
            font: buttonFont, color: Color.LightPink.first, displayMode: displayMode
        )
        
        let deleteButtonLabel = EKProperty.LabelContent(
            text: "DELETE".localized(), style: deleteButtonLabelStyle
        )
        
        let deleteButton = EKProperty.ButtonContent(
            label: deleteButtonLabel, backgroundColor: .clear,
            highlightedBackgroundColor: Color.Teal.a600.with(alpha: 0.05), displayMode: displayMode) {
            SwiftEntryKit.dismiss()
            guard let commentID = self.toBeDeleteCommentID else { return }
            ArticleManager.shared.deleteComment(articleID: self.article.id, commentID: commentID)
            self.fetchComments(articleID: self.article.id)
        }
        
        // Generate the content
        var buttonsBarContent = EKProperty.ButtonBarContent(
            with: deleteButton, closeButton, separatorColor: Color.Gray.light,
            displayMode: displayMode, expandAnimatedly: true
        )
        
        if type == .block {
            buttonsBarContent = EKProperty.ButtonBarContent(
                with: blockButton, closeButton, separatorColor: Color.Gray.light,
                displayMode: displayMode, expandAnimatedly: true
            )
        }
        
        return buttonsBarContent
    }
    
    func showAlertView(type: AlertType, attributes: EKAttributes) {
        let simpleMessage = setUpAlertTitleSection(type: type)
        let buttonsBarContent = setUpAlertButtons(type: type)
        let alertMessage = EKAlertMessage(simpleMessage: simpleMessage, buttonBarContent: buttonsBarContent)
        let contentView = EKAlertMessageView(with: alertMessage)
        SwiftEntryKit.display(entry: contentView, using: attributes)
    }
    
    func configureTextfield() {
        commentTextfield.placeholder = "   Leave a comment...".localized()
        commentTextfield.layer.cornerRadius = 21
        commentTextfield.clipsToBounds = true
    }
    
    // MARK: - IBActions
    
    @IBAction func backToArticle(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func showMoreInfo(_ sender: Any) {
        showActionSheet()
    }
    
    @IBAction func shareArticle(_ sender: Any) {
        guard let userName = UserManager.shared.currentUser?.name else { return }
        let text = "你的朋友 ".localized() + String(userName) + " 剛跟你分享了一篇文章: ".localized() + String(article.title) + "."
        let image = UIImage(named: "Rosa")
        let myWebsite = NSURL(string: "rosa://?\(article.id)")
        let shareAll = [text, image as Any, myWebsite as Any] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func editingDidEnd(_ sender: UITextField) {
        if let text = sender.text {
            if !text.isEmpty {
                ArticleManager.shared.postComment(documentID: article.id, comment: text)
            } else {
                return
            }
        }
        commentTextfield.text = ""
    }
    
    func configureFollowButton() {
        followButton.setTitle("FollowButton".localized(), for: .normal)
        followButton.setTitleColor(UIColor.rgb(red: 229, green: 131, blue: 85, alpha: 1), for: .selected)
        followButton.setTitle("FollowingButton".localized(), for: .selected)
        followButton.setTitleColor(.systemGray2, for: .selected)
        if followButton.isSelected {
            followButton.buttonBorderColor = UIColor.systemGray3
        } else {
            followButton.buttonBorderColor = UIColor.rgb(red: 229, green: 131, blue: 85, alpha: 1)
        }
    }
    
    @IBAction func followAuthor(_ sender: UIButton) {
        if sender.isSelected {
            ArticleManager.shared.removeFromFollowed(authorID: article.authorID)
        } else {
            ArticleManager.shared.addToFollowed(authorID: article.authorID)
        }
        followButton.isSelected = !followButton.isSelected
        configureFollowButton()
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
        if filteredBlockComments.isEmpty {
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
            if comments.count <= 1 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: "NoCommentCell",
                                                            for: indexPath) as? NoCommentCell {
                    return cell
                }
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell",
                                                               for: indexPath) as? CommentCell,
                      let comments = filteredBlockComments else { return UITableViewCell() }
                cell.configureCommentCell(comment: comments[indexPath.row-2])
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 500
        } else {
            return UITableView.automaticDimension
        }
    }
    
}
