//
//  NotificationsViewController.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {

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
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func addNoNotificationsView() {
        tableView.isHidden = true
        view.addSubview(noNotificationsView)
        noNotificationsView.frame = CGRect(x: 0, y: 0, width: view.width/2, height: view.width/4)
        noNotificationsView.center = view.center
    }
}

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        return cell
    }
    
    
}
