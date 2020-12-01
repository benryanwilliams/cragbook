//
//  UserFollowTableViewCell.swift
//  Cragbook
//
//  Created by Ben Williams on 28/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

protocol UserFollowTableViewCellDelegate: AnyObject {
    func didTapFollowUnfollowButton(model: UserRelationship)
}

enum FollowState {
    case following // Indicates the current user is following the other user
    case notFollowing // Indicated the current user is not following the other user
}

struct UserRelationship {
    let username: String
    let name: String
    var type: FollowState
}

class UserFollowTableViewCell: UITableViewCell {
    public static let identifier = "UserFollowTableViewCell"
    
    weak var delegate: UserFollowTableViewCellDelegate?
    
    private var model: UserRelationship?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.numberOfLines = 1
        label.text = "Ben"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 1
        label.textColor = .secondaryLabel
        label.text = "@ben"
        return label
    }()
    
    private let followUnfollowButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .link
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(usernameLabel)
        addSubview(followUnfollowButton)
        selectionStyle = .none
        
        followUnfollowButton.addTarget(self, action: #selector(didTapFollowUnfollowButton), for: .touchUpInside)
        
    }
    
    @objc private func didTapFollowUnfollowButton() {
        guard let model = model else {
            return
        }
        delegate?.didTapFollowUnfollowButton(model: model)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserRelationship) {
        self.model = model
        nameLabel.text = model.name
        usernameLabel.text = model.username
        switch model.type {
        case .following:
            // Show unfollow button
            followUnfollowButton.setTitle("Unfollow", for: .normal)
            followUnfollowButton.setTitleColor(.label, for: .normal)
            followUnfollowButton.backgroundColor = .systemBackground
            followUnfollowButton.layer.borderWidth = 1
            followUnfollowButton.layer.borderColor = UIColor.label.cgColor
        case .notFollowing:
            // Show follow button
            followUnfollowButton.setTitle("Follow", for: .normal)
            followUnfollowButton.setTitleColor(.white, for: .normal)
            followUnfollowButton.backgroundColor = .link
            followUnfollowButton.layer.borderWidth = 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = nil
        nameLabel.text = nil
        usernameLabel.text = nil
        followUnfollowButton.setTitle(nil, for: .normal)
        followUnfollowButton.layer.borderWidth = 0
        followUnfollowButton.backgroundColor = nil
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        profileImageView.frame = CGRect(x: 3,
                                        y: 3,
                                        width: contentView.height / 6,
                                        height: contentView.height / 6)
        
        profileImageView.layer.cornerRadius = profileImageView.height / 2
        
        // If the width of the content view is more than 500 (e.g. iPad) then the button width will be 220, otherwise it will be the width of the content view divided by 3
        let buttonWidth = contentView.width > 500 ? 220.0 : contentView.width / 3
        
        followUnfollowButton.frame = CGRect(x: contentView.width - 5 - buttonWidth,
                                            y: (contentView.height - 40) / 2,
                                            width: buttonWidth,
                                            height: 40)
        
        let labelHeight = contentView.height / 2
        
        nameLabel.frame = CGRect(x: profileImageView.right + 5,
                                 y: 0,
                                 width: contentView.width - 8 - profileImageView.width - buttonWidth,
                                 height: labelHeight)
        
        usernameLabel.frame = CGRect(x: profileImageView.right + 5,
                                     y: nameLabel.bottom,
                                     width: contentView.width - 8 - profileImageView.width - buttonWidth,
                                     height: labelHeight)
    }
    
}
