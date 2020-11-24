//
//  ProfileInfoHeaderCollectionReusableView.swift
//  Cragbook
//
//  Created by Ben Williams on 23/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

class ProfileInfoHeaderCollectionReusableView: UICollectionReusableView {
        static let identifier = "ProfileInfoHeaderCollectionReusableView"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
