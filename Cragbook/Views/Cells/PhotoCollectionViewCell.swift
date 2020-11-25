//
//  PhotoCollectionViewCell.swift
//  Cragbook
//
//  Created by Ben Williams on 23/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import SDWebImage
import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        photoImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(photoImageView)
        contentView.clipsToBounds = true
        
        // These are for visually impaired users and will generate voiceovers for the cell
        accessibilityLabel = "User post image"
        accessibilityHint = "Double-tap to open post"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with model: UserPost) {
        let thumbnailURL = model.thumbnailImageURL
        
        // SDWebImage pod used for setting image from URL
        photoImageView.sd_setImage(with: thumbnailURL, completed: nil)
        
    }
    
    // TODO:- Delete this once configure above has been completed - only used for test purposes
    public func configure(debug imageName: String) {
        let image = UIImage(named: imageName)
        photoImageView.image = image
    }
    
}
