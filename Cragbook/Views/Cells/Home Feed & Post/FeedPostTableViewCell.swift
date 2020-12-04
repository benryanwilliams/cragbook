//
//  FeedPostTableViewCell.swift
//  Cragbook
//
//  Created by Ben Williams on 21/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import AVFoundation
import SDWebImage
import UIKit

/// Cell for primary post content
class FeedPostTableViewCell: UITableViewCell {
    static let identifier = "FeedPostTableViewCell"
    
    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = nil
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var player: AVPlayer?
    private var playerLayer = AVPlayerLayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //  N.B. ALWAYS ADD SUBLAYERS BEFORE ADDING SUBVIEWS
        
        //  A layer is simply a graphical representation, while a UIView can accept user interaction (a UIView is just a layer with a thin layer on top of it, hence the fact that you can access layers of UIViews with myUIView.layer.cornerRadius etc.). Layers should be used for things that don't need user interaction with as they use less power and also can be customised more easily
        contentView.layer.addSublayer(playerLayer)
        contentView.addSubview(postImageView)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with post: UserPost) {
        postImageView.image = UIImage(named: "test")
        
        return
        
        // Configure the cell
        switch post.postType {
        case .photo:
            // Show image
            postImageView.sd_setImage(with: post.postURL, completed: nil)
            
        case .video:
            // Load and play video
            player = AVPlayer(url: post.postURL)
            playerLayer.player = player
            playerLayer.player?.volume = 0
            playerLayer.player?.play()
            
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        
    }
    
    
}
