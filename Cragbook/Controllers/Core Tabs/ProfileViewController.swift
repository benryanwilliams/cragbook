//
//  ProfileViewController.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

/// Profile view controller
final class ProfileViewController: UIViewController {

    private var collectionView: UICollectionView?
    
    private var userPosts = [UserPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        configureNavigationBar()
        
        // Set up collection view attributes
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        let size = (view.width - 4)/3
        layout.itemSize = CGSize(width: size, height: size)
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        
        // Register cell to collection view
        collectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        // Register headers to collection view
        collectionView?.register(ProfileInfoHeaderCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier)
        
        collectionView?.register(ProfileTabsCollectionReusableView.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: ProfileTabsCollectionReusableView.identifier)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        // This creates a constant called collectionView (providing collectionView is not nil) to be used in the addSubview function below
        guard let collectionView = self.collectionView else {
            return
        }
        
        view.addSubview(collectionView)
    }
    
    override func viewDidLayoutSubviews() {
        collectionView?.frame = view.bounds
    }
    
    // Add settings button to nav bar
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: (UIImage(systemName: "gear")),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSettingsButton))
    }
    
    @objc private func didTapSettingsButton() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
     }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // No items for the first section
        if section == 0 {
            return 0
        }
        // Number of items in the second section
        
        // return userPosts.count
        return 30
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let model = userPosts[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        
//        cell.configure(with: model)
        cell.configure(debug: "test")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        // Get the model and open post controller
        
//        let model = userPosts[indexPath.row]
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
        
        let vc = PostViewController(model: post)
        vc.title = post.postType.rawValue 
        
        // Disable large title mode for the navigation controller
        navigationItem.largeTitleDisplayMode = .never
        
        // Push the PostViewController onto the navigation stack
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // Add header to collectionView
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // Ensure that the supplementary element is a header (not a footer) otherwise return empty reusable view
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        // Section 1 (second section) header
        if indexPath.section == 1 {
            // Tabs header - Create header from ProfileTabsCollectionReusableView
            let tabControlHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileTabsCollectionReusableView.identifier, for: indexPath) as! ProfileTabsCollectionReusableView
            
            tabControlHeader.delegate = self
            
            return tabControlHeader
        }
        
        // Section 0 (first section)
        // Profile header - Create header from ProfileInfoHeaderCollectionReusableView
        let profileHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileInfoHeaderCollectionReusableView.identifier, for: indexPath) as! ProfileInfoHeaderCollectionReusableView
        
        profileHeader.delegate = self
        
        return profileHeader
    }
    
    // Specify size of header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        // Apply size to header above the first section
        if section == 0 {
            return CGSize(width: collectionView.width,
                          height: collectionView.height / 3)
        }
        // Apply size to header above second section
        return CGSize(width: collectionView.width, height: 50)
    }
    
    
}

// MARK:- ProfileInfoHeaderCollectionReusableViewDelegate

extension ProfileViewController: ProfileInfoHeaderCollectionReusableViewDelegate {
    func profileHeaderDidTapPostsButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        // Scroll to posts section
        collectionView?.scrollToItem(at: IndexPath(row: 0, section: 1), at: .top, animated: true)
    }
    
    func profileHeaderDidTapFollowersButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        // Open list of followers
        
        var mockData = [UserRelationship]()
        
        for x in 0...10 {
            mockData.append(UserRelationship(username: "@ben", name: "Ben", type: x % 2 == 0 ? .following : .notFollowing)) // If x is even then set to 'following', if not then set to 'not following'
        }
        
        let vc = ListViewController(data: mockData)
        vc.title = "Followers"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderDidTapFollowingButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        // Open list of following
        
        var mockData = [UserRelationship]()
        
        for x in 0...10 {
            mockData.append(UserRelationship(username: "@ben", name: "Ben", type: x % 2 == 0 ? .following : .notFollowing)) // If x is even then set to 'following', if not then set to 'not following'
        }
        
        let vc = ListViewController(data: mockData)
        vc.title = "Following"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func profileHeaderDidTapEditProfileButton(_ header: ProfileInfoHeaderCollectionReusableView) {
        // Present edit profile screen
        let vc = EditProfileViewController()
        vc.title = "Edit Profile"
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    
}

// MARK:- ProfileInfoHeaderCollectionReusableViewDelegate

extension ProfileViewController: ProfileTabsCollectionReusableViewDelegate {
    func didTapGridButton(_ header: ProfileTabsCollectionReusableView) {
        // Reload collection view with data
        
    }
    
    func didTapTaggedButton(_ header: ProfileTabsCollectionReusableView) {
        // Reload collection view with data 
        
    }
    
    
}
