//
//  NotificationsFollowEventTableViewCell.swift
//  Cragbook
//
//  Created by Ben Williams on 01/12/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

protocol NotificationsFollowEventTableViewCellDelegate: AnyObject {
    func didTapFollowUnfollowButton(model: UserNotification)
}

class NotificationsFollowEventTableViewCell: UITableViewCell {
    static let identifier = "NotificationsFollowEventTableViewCell"
    
    public weak var delegate: NotificationsFollowEventTableViewCellDelegate?
    
    private var model: UserNotification?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "@KanyeWest started following you."
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
        contentView.addSubview(followButton)
        
        selectionStyle = .none
        
        followButton.addTarget(self, action: #selector(didTapFollowButton), for: .touchUpInside)
        
        configureForFollow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func didTapFollowButton() {
        guard let model = model else {
            return
        }
        self.delegate?.didTapFollowUnfollowButton(model: model)
    }
    
    public func configure(with model: UserNotification) {
        self.model = model
        
        switch model.type {
        // In the case that it is a 'like' notification, extract the UserPost data from the model and set it to a new constant called 'post' (of type UserPost), so that it can be used to generate a thumbnail image
        case .like(_):
            break
        case .follow(let state):
            // Configure button
            switch state {
            case .following:
                // Show unfollow button
                configureForFollow()
                
            case .notFollowing:
                // Show follow button
                followButton.setTitle("Follow", for: .normal)
                followButton.setTitleColor(.white, for: .normal)
                followButton.layer.borderWidth = 0
                followButton.backgroundColor = .link
                
            }
            break
        }
        
        label.text = model.text
        profileImageView.sd_setImage(with: model.user.profilePhoto, completed: nil)
    }
    
    private func configureForFollow() {
        followButton.setTitle("Unfollow", for: .normal)
        followButton.setTitleColor(.label, for: .normal)
        followButton.layer.borderWidth = 1
        followButton.layer.borderColor = UIColor.secondaryLabel.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        followButton.setTitle(nil, for: .normal)
        followButton.backgroundColor = nil
        followButton.layer.borderWidth = 0
        
        label.text = nil
        
        profileImageView.image = nil
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 3,
                                        y: 3,
                                        width: contentView.height - 6,
                                        height: contentView.height - 6)
        
        profileImageView.layer.cornerRadius = profileImageView.height / 2
        
        let size: CGFloat = 100
        let buttonHeight: CGFloat = 40
        followButton.frame = CGRect(x: contentView.width - 5 - size,
                                    y: (contentView.height - buttonHeight)/2,
                                    width: size,
                                    height: buttonHeight)
        
        followButton.layer.cornerRadius = 4
        followButton.layer.masksToBounds = true
        
        label.frame = CGRect(x: profileImageView.right + 5,
                             y: 0,
                             width: width - size - profileImageView.width - 16,
                             height: contentView.height)
    }
    
    
}
