//
//  ArticleDetailViewController.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/5/19.
//

import UIKit

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
    
    var comments: [Comment] = [Comment(id: "fail", author: "fail", content: "fail", date: Date())] {
        didSet {
            tableView.reloadData()
        }
    }
 
    override func viewDidLoad() {

        super.viewDidLoad()
        authorName.text = article.author
        configureTextfield()
        fetchComments(articleID: article.id)

    }
    
    override func viewWillAppear(_ animated: Bool) {

        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {

        self.tabBarController?.tabBar.isHidden = false

    }
    
    @IBAction func backToArticle(_ sender: Any) {

        self.navigationController?.popViewController(animated: true)

    }
    
    func configureTextfield() {
        
        commentTextfield.layer.cornerRadius = 21
        commentTextfield.clipsToBounds = true
        
    }

    @IBAction func likedArticle(_ sender: Any) {

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
        if comments.count == 1 {
            return 3
        } else {
            return comments.count+1
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
                    cell.configureCommentCell(comment: comments[indexPath.row-2])
                    
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
//            return 1230
            return UITableView.automaticDimension
        default:
//            return 120
            return UITableView.automaticDimension
        }
    }

}
