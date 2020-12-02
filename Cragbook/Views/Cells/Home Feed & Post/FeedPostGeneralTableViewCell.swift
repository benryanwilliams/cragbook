//
//  IGFeedPostGeneralTableViewCell.swift
//  Cragbook
//
//  Created by Ben Williams on 21/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

/// Comments
class FeedPostGeneralTableViewCell: UITableViewCell {
    static let identifier = "FeedPostGeneralTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .orange
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure() {
        // Configure the cell
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
