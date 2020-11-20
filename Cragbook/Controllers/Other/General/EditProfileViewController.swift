//
//  EditProfileViewController.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSave))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                                   style: .done,
                                                                   target: self,
                                                                   action: #selector(didTapCancel))
        
    }
    
    @objc private func didTapSave() {
        
    }
    
    @objc private func didTapCancel() {
    
    }
    
    @objc private func didTapChangeProfilePicture() {
        let actionSheet = UIAlertController(title: "Profile picture", message: "Change profile picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction((UIAlertAction(title: "Take photo", style: .default, handler: { _ in
            
        })))
        actionSheet.addAction((UIAlertAction(title: "Choose from library", style: .default, handler: { _ in
            
        })))
        actionSheet.addAction((UIAlertAction(title: "Cancel", style: .cancel, handler: nil
            
        )))
        
        actionSheet.popoverPresentationController?.sourceView = view
        actionSheet.popoverPresentationController?.sourceRect = view.bounds
        
        present(actionSheet, animated: true)
    }
    
}
