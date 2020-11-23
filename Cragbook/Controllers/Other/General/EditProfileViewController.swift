//
//  EditProfileViewController.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

// Model for rows on the edit profile screen
struct EditProfileFormModel {
    let label: String // The title of the field
    let placeholder: String // Placeholder in the text field
    var value: String? // The text entered into the text field by the user
}

final class EditProfileViewController: UIViewController {
    
    // Create table view
    private let tableView: UITableView = {
        let tableView = UITableView()
        // Register custom class (defined within FormTableViewCell.swift) for creating table view cells
        tableView.register(FormTableViewCell.self, forCellReuseIdentifier: FormTableViewCell.identifier)
        return tableView
    }()
    
    // Create empty 2D array of EditProfileFormModel objects (2D as table view rows are separated into sections)
    private var models = [[EditProfileFormModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add labels and placeholders for each profile element to models array (see below)
        configureModels()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        
        // Add header to table view to contain profile picture (see below)
        tableView.tableHeaderView = createTableHeaderView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Add save and cancel buttons to nav bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapCancel))
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configureModels() {
        // Section 1 - Name, username, website, bio
        let sectionOneLabels = ["Name", "Username", "Website", "Bio"]
        
        // For each of the items within the sectionOneLabels array above, assign this to the label and placeholder and add to the models array
        var sectionOne = [EditProfileFormModel]()
        for label in sectionOneLabels {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
            sectionOne.append(model)
        }
        models.append(sectionOne)
        
        // Section 2 - Email, phone, gender
        let sectionTwoLabels = ["Email", "Phone", "Gender"]
        
        // For each of the items within the sectionTwoLabels array above, assign this to the label and placeholder and add to the models array
        var sectionTwo = [EditProfileFormModel]()
        for label in sectionTwoLabels {
            let model = EditProfileFormModel(label: label, placeholder: "Enter \(label)...", value: nil)
            sectionTwo.append(model)
        }
        models.append(sectionTwo)
    }
    
    // Create header containing profile picture with ability to edit profile photo by tapping on it
    private func createTableHeaderView() -> UIView {
        // 'Integral' rounds up all values for the rectangle to the nearest integer, just in case we're using any floating point values
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.height/4).integral)
        let size = header.height / 1.5
        let profilePhotoButton = UIButton(frame: CGRect(x: (view.width - size)/2,
                                                        y: (header.height - size)/2,
                                                        width: size,
                                                        height: size))
        header.addSubview(profilePhotoButton)
        profilePhotoButton.layer.masksToBounds = true
        profilePhotoButton.layer.cornerRadius = size / 2 // Creates a circle
        
        profilePhotoButton.addTarget(self, action: #selector(didTapProfilePhotoButton), for: .touchUpInside)
        
        profilePhotoButton.setBackgroundImage(UIImage(systemName: "person.circle"), for: .normal)
        profilePhotoButton.tintColor = .label
        profilePhotoButton.layer.borderWidth = 1
        profilePhotoButton.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        
        return header
    }
    
    // MARK:- Actions
    
    // TODO:- didTapSave
    @objc private func didTapSave() {
        dismiss(animated: true, completion: nil)
        // Save info to database
        
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapChangeProfilePicture() {
        
        // Present action sheet so user can select to take a picture, choose from library or cancel
        let actionSheet = UIAlertController(title: "Profile picture", message: "Change profile picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction((UIAlertAction(title: "Take photo", style: .default, handler: { _ in
            
        })))
        actionSheet.addAction((UIAlertAction(title: "Choose from library", style: .default, handler: { _ in
            
        })))
        actionSheet.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: nil
            
        )))
        
        // iPad specific action sheet settings
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        
        present(actionSheet, animated: true)
    }
    
    @objc private func didTapProfilePhotoButton() {
        
    }
 
}

// MARK:- Table view datasource and delegate methods

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].count
    }
    
    // Get the model (including label, placeholder and value) at the index path (within the relevant section) from the models array and add this to the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: FormTableViewCell.identifier, for: indexPath) as! FormTableViewCell
        cell.delegate = self
        cell.configure(with: model)
        return cell
    }

    // Add headers to table view sections
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section == 1 else {
            return nil
        }
        return "Private information"
        
        
    }
    
    
}

// MARK:- formTableViewCell delegate methods

extension EditProfileViewController: FormTableViewCellDelegate {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateTextField updatedModel: EditProfileFormModel) {
        
         print("Field updated to \(updatedModel.value ?? "nil")")
        
        // TODO: Store textfield text in value of models array
        
        // TODO: Transfer to storage
    }
    
    
}
