//
//  PhotoCell.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/13/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    static let reuseIdentifier = "\(PhotoCell.self)"
    
    // Add image view. 
    
    let imageView = UIImageView()
    
    override func layoutSubviews() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for imageView
        
        NSLayoutConstraint.activateConstraints([
            imageView.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor),
            imageView.topAnchor.constraintEqualToAnchor(contentView.topAnchor),
            imageView.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor),
            imageView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor),
        ])
    }
    
}
