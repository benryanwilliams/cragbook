//
//  ViewController.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    
    struct HomeFeedRenderViewModel {
        let header: PostRenderViewModel
        let post: PostRenderViewModel
        let actions: PostRenderViewModel
        let comments: PostRenderViewModel
    }
    
    private var feedRenderModels = [HomeFeedRenderViewModel]()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FeedPostTableViewCell.self,
                           forCellReuseIdentifier: FeedPostTableViewCell.identifier)
        tableView.register(FeedPostHeaderTableViewCell.self,
                           forCellReuseIdentifier: FeedPostHeaderTableViewCell.identifier)
        tableView.register(FeedPostActionsTableViewCell.self,
                           forCellReuseIdentifier: FeedPostActionsTableViewCell.identifier)
        tableView.register(FeedPostGeneralTableViewCell.self,
                           forCellReuseIdentifier: FeedPostGeneralTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        createMockModels()
    }
    
    private func createMockModels() {
        let user = User(username: "@joe",
                        bio: "Joe's Bio goes here.",
                        name: ("Joe", "Sausage"),
                        profilePhoto: URL(string: "https://google.com")!,
                        birthDate: Date(),
                        gender: .male,
                        counts: UserCount(followers: 40, following: 20, posts: 10),
                        joinDate: Date())
        
        let post = UserPost(identifier: "242423",
                            postType: .photo,
                            thumbnailImageURL: URL(string: "https://google.com")!,
                            postURL: URL(string: "https://google.com")!,
                            caption: nil,
                            likes: [],
                            comments: [],
                            createdDate: Date(),
                            taggedUsers: [],
                            owner: user)
        
        var comments = [PostComment]()
        for x in 0..<2 {
            comments.append(PostComment(identifier: "123\(x)", username: "@dave", text: "Siiiiick mangggg", createdDate: Date(), likes: []))
        }
        
        for x in 0..<5 {
            
            let viewModel = HomeFeedRenderViewModel(
                header: PostRenderViewModel(renderType: .header(provider: user)),
                post: PostRenderViewModel(renderType: .primaryContent(provider: post)),
                actions: PostRenderViewModel(renderType: .actions(provider: "")),
                comments: PostRenderViewModel(renderType: .comments(comments: comments)))
            
            feedRenderModels.append(viewModel)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleNotAuthenticated()
    }
    
    private func handleNotAuthenticated() {
        // Check auth status to see whether user is already signed in
        if Auth.auth().currentUser == nil {
            // If user is not signed in then show login screen
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            present(loginVC, animated: false, completion: nil)
        }
    }
    
    
}

// MARK:- TableView Delegate and Data Source Methods

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return feedRenderModels.count * 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let x = section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }
        else {
            let position = x % 4 == 0 ? (x % 4) : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
            
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            // Header
            return 1
        }
        else if subSection == 1 {
            // Post
            return 1
        }
        else if subSection == 2 {
            // Actions
            return 1
        }
        else if subSection == 3 {
            // Comments
            let commentsModel = model.comments
            switch commentsModel.renderType {
            case .comments(let comments) : return comments.count > 2 ? 2 : comments.count
            case .header, .primaryContent, .actions: return 0
            }
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let x = indexPath.section
        let model: HomeFeedRenderViewModel
        if x == 0 {
            model = feedRenderModels[0]
        }
        else {
            let position = x % 4 == 0 ? (x % 4) : ((x - (x % 4)) / 4)
            model = feedRenderModels[position]
            
        }
        
        let subSection = x % 4
        
        if subSection == 0 {
            // Header
            switch model.header.renderType {
            case .header(let user):
                let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostHeaderTableViewCell.identifier, for: indexPath) as! FeedPostHeaderTableViewCell
                cell.configure(with: user)
                cell.delegate = self
                return cell
            case .actions, .comments, .primaryContent: return UITableViewCell()
            }
        }
        else if subSection == 1 {
            // Post
            switch model.post.renderType {
            case .primaryContent(let post):
                let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostTableViewCell.identifier, for: indexPath) as! FeedPostTableViewCell
                cell.configure(with: post)
                return cell
            case .actions, .comments, .header: return UITableViewCell()
            }
        }
        else if subSection == 2 {
            // Actions
            switch model.actions.renderType {
            case .actions(let provider):
                let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostActionsTableViewCell.identifier, for: indexPath) as! FeedPostActionsTableViewCell
                cell.delegate = self
                return cell
            case .primaryContent, .comments, .header: return UITableViewCell()
            }
        }
        else if subSection == 3 {
            // Comments
            switch model.comments.renderType {
            case .comments(let comments):
                let cell = tableView.dequeueReusableCell(withIdentifier: FeedPostGeneralTableViewCell.identifier, for: indexPath) as! FeedPostGeneralTableViewCell
                return cell
            case .actions, .primaryContent, .header: return UITableViewCell()
            }
        }
        else {
            return UITableViewCell()
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let subSection = indexPath.section % 4
        
        if subSection == 0 {
            // Header
            return 70
        }
        else if subSection == 1 {
            // Post
            return tableView.width
        }
        else if subSection == 2 {
            // Actions (Like / Comment)
            return 60
        }
        else if subSection == 3 {
            // Comment row
            return 50
        }
        else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        let subSection = section % 4
        return subSection == 3 ? 70 : 0
    }
    
}

// MARK:- FeedPostHeaderTableViewCellDelegate

extension HomeViewController: FeedPostHeaderTableViewCellDelegate {
    func didTapMoreButton() {
        // Show action sheet
        let actionSheet = UIAlertController(title: "More options", message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Report post", style: .destructive, handler: { [weak self] _ in
            self?.reportPost()
        }))
        present(actionSheet, animated: true)
    }
    
    func reportPost() {
        
    }
    
    
}

// MARK:- FeedPostActionsTableViewCellDelegate

extension HomeViewController: FeedPostActionsTableViewCellDelegate {
    func didTapLikeButton() {
        print("Like button tapped")
    }
    
    func didTapCommentButton() {
        print("Comment button tapped")
    }
    
    func didTapSendButton() {
        print("Send button tapped")
    }
    
    
}
