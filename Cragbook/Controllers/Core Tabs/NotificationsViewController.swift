//
//  NotificationsViewController.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

// Define user notification types 'like' and 'follow'. If it is a 'like' notification then it takes a UserPost input to allow the original post to be reached by tapping on the thumbnail
enum UserNotificationType {
    case like(post: UserPost)
    case follow(state: FollowState)
}

struct UserNotification {
    let type: UserNotificationType
    let text: String
    let user: User
}

final class NotificationsViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        //        tableView.isHidden = true
        tableView.register(NotificationsFollowEventTableViewCell.self, forCellReuseIdentifier: NotificationsFollowEventTableViewCell.identifier)
        tableView.register(NotificationsLikeEventTableViewCell.self, forCellReuseIdentifier: NotificationsLikeEventTableViewCell.identifier)
        return tableView
    }()
    
    private let spinner : UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.tintColor = .label
        return spinner
    }()
    
    // lazy means that this view will only be instantiated when we call it (won't need to create the view if the user has notifications)
    private lazy var noNotificationsView = NoNotificationsView()
    
    private var models = [UserNotification]()
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        navigationItem.title = "Notifications"
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(spinner)
        //        spinner.startAnimating()
        
        view.addSubview(tableView)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        
        spinner.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        spinner.center = view.center
    }
    
    private func fetchNotifications() {
        for x in 0...100 {
            if x % 2 == 0 {
                models.append(UserNotification(type: .follow(state: .notFollowing ),
                                               text: "@joe followed you.",
                                               user: User(username: "Joe",
                                                          bio: "Joe's Bio goes here.",
                                                          name: ("Joe", "Sausage"),
                                                          profilePhoto: URL(string: "https://google.com")!,
                                                          birthDate: Date(),
                                                          gender: .male,
                                                          counts: UserCount(followers: 40, following: 20, posts: 10),
                                                          joinDate: Date())))
            }
            else {
                let post = UserPost(identifier: "242423", postType: .photo, thumbnailImageURL: URL(string: "https://google.com")!, postURL: URL(string: "https://google.com")!, caption: nil, likes: [], comments: [], createdDate: Date(), taggedUsers: [])
                
                models.append(UserNotification(type: .like(post: post), text: "@dave liked your post.", user: User(username: "Dave", bio: "Dave's Bio goes here.", name: ("Joe", "Sausage"), profilePhoto: URL(string: "https://google.com")!, birthDate: Date(), gender: .male, counts: UserCount(followers: 40, following: 20, posts: 10), joinDate: Date())))
            }
        }
    }
    
    private func addNoNotificationsView() {
        tableView.isHidden = true
        view.addSubview(noNotificationsView)
        noNotificationsView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotificationsView.center = view.center
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        switch model.type {
            
        case .follow:
            // Follow cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsFollowEventTableViewCell.identifier, for: indexPath) as! NotificationsFollowEventTableViewCell
            //            cell.configure(with: model)
            cell.delegate = self
            return cell
            
        case .like:
            // Like cell
            let cell = tableView.dequeueReusableCell(withIdentifier: NotificationsLikeEventTableViewCell.identifier, for: indexPath) as! NotificationsLikeEventTableViewCell
            cell.configure(with: model)
            cell.delegate = self
            return cell
        }
        //        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 52
    }
    
    
}

extension NotificationsViewController: NotificationsLikeEventTableViewCellDelegate {
    func didTapRelatedPostButton(model: UserNotification) {
        print("Related post button tapped")
        // Open related post
    }
    
    
}

extension NotificationsViewController: NotificationsFollowEventTableViewCellDelegate {
    
    func didTapFollowUnfollowButton(model: UserNotification) {
        print("Follow / unfollow button tapped")
        // Perform database update to follow / unfollow user
    }
    
    
}
