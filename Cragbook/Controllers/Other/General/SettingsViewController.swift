//
//  SettingsViewController.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

// Model for cells in tableView
struct SettingCellModel {
    let title: String
    let handler: (() -> Void)
}

/// View Controller to show user settings
final class SettingsViewController: UIViewController { // 'final' just means that it can't be subclassed
    
    // Create tableView programmatically
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        // .self accesses the UITableViewCell type itself rather than an instance of it.
        // Explanation: Just like String is the type and "Hello World" is the value of an instance, String.Type is the type and String.self is the value of a metatype.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    // This is a two-dimensional array since we have two levels (sections and rows) in the tableView
    private var data = [[SettingCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        configureModel()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // This creates a section for the log out cell. When tapped, the completion handler runs the didTapLogOut method. 'weak self' should always be used when referencing 'self' in a closure to prevent a memory leak.
    private func configureModel() {
        let section = [SettingCellModel(title: "Log Out") { [weak self] in
            self?.didTapLogOut()
            }
        ]
        
        data.append(section)
    }
    
    private func didTapLogOut() {
        let actionSheet = UIAlertController(title: "Log out", message: "Are you sure you want to log out?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { _ in
            AuthManager.shared.logOutUser { loggedOut in
                DispatchQueue.main.async {
                    if loggedOut {
                        // Present log in screen
                        let vc = LoginViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true) {
                            // Following two lines of code  ensure that when the user logs back in again, they are presented with the home screen rather than the settings screen, and that the tab bar has the home button selected
                            self.navigationController?.popToRootViewController(animated: false)
                            self.tabBarController?.selectedIndex = 0
                            
                        }
                    }
                    else {
                        // Error
                        fatalError("Could not log out user")
                        
                    }
                }
            }
        }))
        
        // The following two lines are iPad specific, without these it won't know how to display the action sheet and it'll crash
        actionSheet.popoverPresentationController?.sourceView = tableView
        actionSheet.popoverPresentationController?.sourceRect = tableView.bounds
        
        present(actionSheet, animated: true)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle cell selection using the completion handler declared in the SettingCellModel struct
        data[indexPath.section][indexPath.row].handler()
    }
    
    
}
