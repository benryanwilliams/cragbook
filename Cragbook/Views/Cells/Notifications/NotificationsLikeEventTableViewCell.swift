//
//  NotificationsLikeEventTableViewCell.swift
//  Cragbook
//
//  Created by Ben Williams on 01/12/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

protocol NotificationsLikeEventTableViewCellDelegate: AnyObject {
    func didTapRelatedPostButton(model: String )
}

class NotificationsLikeEventTableViewCell: UITableViewCell {
    static let identifier = "NotificationsLikeEventTableViewCell"
    
    public weak var delegate: NotificationsLikeEventTableViewCellDelegate?
    
    private let profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let postButton: UIButton = {
       let button = UIButton()
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(profileImageView)
        contentView.addSubview(label)
        contentView.addSubview(postButton)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: String) {
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postButton.setBackgroundImage(nil, for: .normal)
        
        label.text = nil
        
        profileImageView.image = nil
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = CGRect(x: 5, y: 5, width: 30, height: 30)
        label.frame = CGRect(x: profileImageView.right + 5, y: 5, width: width - profileImageView.width - 10, height: height - 10)
    }
    

}

