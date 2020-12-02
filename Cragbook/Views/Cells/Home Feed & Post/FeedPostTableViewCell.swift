//
//  FeedPostTableViewCell.swift
//  Cragbook
//
//  Created by Ben Williams on 21/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

class FeedPostTableViewCell: UITableViewCell {
    static let identifier = "FeedPostTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .red
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
