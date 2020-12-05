//
//  ExploreViewController.swift
//  Cragbook
//
//  Created by Ben Williams on 15/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

// See ProfileViewController file for notes on set up of collection views
class ExploreViewController: UIViewController {
    
    // Create search bar
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.backgroundColor = .secondarySystemBackground
        return searchBar
    }()
    
    private var models = [UserPost]()
    
    private var exploreCollectionView: UICollectionView?
    
    private var tabbedSearchCollectionView: UICollectionView?
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        view.alpha = 0
        return view
    }()
    
    // MARK:- viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureExploreCollectionView()
        configureSearchBar()
        configureDimmedView()
        configureTabbedSearchCollectionView()
    }
    
    // MARK:- Configure methods
    
    private func configureTabbedSearchCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.width / 3, height: 52)
        tabbedSearchCollectionView = UICollectionView(frame: .zero,
                                                      collectionViewLayout: layout)
        tabbedSearchCollectionView?.isHidden = true
        tabbedSearchCollectionView?.backgroundColor = .yellow
        guard let tabbedSearchCollectionView = tabbedSearchCollectionView else {
            return
        }
        
        tabbedSearchCollectionView.delegate = self
        tabbedSearchCollectionView.dataSource = self
        
        view.addSubview(tabbedSearchCollectionView)
    }
    
    private func configureDimmedView() {
        view.addSubview(dimmedView)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didCancelSearch))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        dimmedView.addGestureRecognizer(gesture)
    }
    
    private func configureSearchBar() {
        navigationController?.navigationBar.topItem?.titleView = searchBar // Add search bar to top of navbar
        searchBar.delegate = self
    }
    
    private func configureExploreCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (view.width-4)/3, height: (view.width-4)/3)
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        exploreCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        exploreCollectionView?.delegate = self
        exploreCollectionView?.dataSource = self
        
        exploreCollectionView?.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        
        guard let collectionView = self.exploreCollectionView else {
            return
        }
        
        view.addSubview(collectionView)
    }
    
    // MARK:- viewDidLayoutSubviews
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        exploreCollectionView?.frame = view.bounds
        dimmedView.frame = view.bounds
        tabbedSearchCollectionView?.frame = CGRect(
            x: 0,
            y: view.safeAreaInsets.top,
            width: view.width,
            height: 72)
    }
}

// MARK:- Collection view delegate, data source and delegate flow methods

extension ExploreViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabbedSearchCollectionView {
            // tabbedSearchCollectionView
            return 0
        }
        else {
            // exploreCollectionView
            return 100
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabbedSearchCollectionView {
            // tabbedSearchCollectionView
            return UICollectionViewCell()
        }
        else {
            // exploreCollectionView
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as? PhotoCollectionViewCell else {
                return UICollectionViewCell()
            }
            // cell.configure(with: )
            cell.configure(debug: "test")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        if collectionView == tabbedSearchCollectionView {
            // tabbedSearchCollectionView has been tapped
            // Change search context
            return
        }
        else {
            // exploreCollectionView has been tapped
            //        let model = models[indexPath.row]
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
            navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    
    
}

// MARK:- Search bar delegate methods

extension ExploreViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        didCancelSearch()
        searchBar.resignFirstResponder()
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        query(with: text)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(didCancelSearch)
        )
        
        dimmedView.isHidden = false
        UIView.animate(withDuration: 0.2,
                       animations: { self.dimmedView.alpha = 0.4 }) {
                        (done) in
                        if done {
                            self.tabbedSearchCollectionView?.isHidden = false
                        }
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        didCancelSearch()
    }
    
    @objc private func didCancelSearch() {
        searchBar.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
        self.tabbedSearchCollectionView?.isHidden = true
        UIView.animate(withDuration: 0.2, animations: {
            self.dimmedView.alpha = 0
        }) { done in
            if done {
                self.dimmedView.isHidden = true
            }
        }
        
    }
    
    private func query(with text: String) {
        // Perform search query in the back end
    }
}
