//
//  FilteredImageCell.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/8/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import UIKit
import GLKit

class FilteredImageCell: UICollectionViewCell {
    
    // Re-use identifier 
    
    static let reuseIdentifier = String(FilteredImageCell.self)
    
    var eaglContext: EAGLContext!
    var ciContext: CIContext!
    
    // Add instance of glkView
    
    lazy var glkView: GLKView = {
       let view = GLKView(frame: self.contentView.frame, context: self.eaglContext)
        view.delegate = self
        return view
    }()
    
    // Reference to image. 
    
    var image: CIImage!
    
    // Layout Cell
    
    override func layoutSubviews() {
        contentView.addSubview(glkView)
        
        // Turn off auto resizing masks 
        glkView.translatesAutoresizingMaskIntoConstraints = false
        
        // Image view will fill entire cell
        
        // Constraints 
        
        NSLayoutConstraint.activateConstraints([
            glkView.topAnchor.constraintEqualToAnchor(contentView.topAnchor),
            glkView.rightAnchor.constraintEqualToAnchor(contentView.rightAnchor),
            glkView.bottomAnchor.constraintEqualToAnchor(contentView.bottomAnchor),
            glkView.leftAnchor.constraintEqualToAnchor(contentView.leftAnchor),
            ])
    }
}

extension FilteredImageCell: GLKViewDelegate {
    
    // Method provides a drawing implementation that renders the drawing onto the actual view
    
    func glkView(view: GLKView, drawInRect rect: CGRect) {
        
        // Create CGSize Value
        let drawableRectSize = CGSize(width: glkView.drawableWidth, height: glkView.drawableHeight)
        
        // Create CGRect to define drawable space
        let drawableRect = CGRect(origin: CGPointZero, size: drawableRectSize)
        
        // Ask context to draw image
        ciContext.drawImage(image, inRect: drawableRect, fromRect: image.extent) 
    }
}
