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
 
    override func viewDidLoad() {

        super.viewDidLoad()
        authorName.text = article.author
        configureTextfield()

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
    
}

extension ArticleDetailViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell",
                                                        for: indexPath) as? CommentCell {
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 500
        case 1:
            return 1230
        default:
            return 120
        }
    }
}
