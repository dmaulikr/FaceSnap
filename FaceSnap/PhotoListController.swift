//
//  ViewController.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/7/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import UIKit

class PhotoListController: UIViewController {
    
    // Add button to main screen 
    
    lazy var cameraButton: UIButton = {
        
        let button = UIButton(type: .System)
        
        // Camera Button Customization
        
        button.setTitle("Camera", forState: .Normal)
        button.tintColor = .whiteColor()
        button.backgroundColor = UIColor(red: 254/255.0, green: 123/255.0, blue: 135/255.0, alpha: 1.0)
        
        button.addTarget(self, action: #selector(PhotoListController.presentImagePickerController), forControlEvents: .TouchUpInside)

        return button
        
    }()
    
    lazy var mediaPickerManager: MediaPickerManager = {
        let manager = MediaPickerManager(presentingViewController: self)
        manager.delegate = self
        return manager
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        
        // Camera Button Layout
        
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([
            cameraButton.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            cameraButton.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            cameraButton.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            cameraButton.heightAnchor.constraintEqualToConstant(56.0)
            ])
    }
    
    // MARK: - Image Picker Controller

    @objc private func presentImagePickerController() {
        mediaPickerManager.presentImagePickerController(animated: true) 
        
    }

}

// MARK: - MediaPickerManagerDelegate

extension PhotoListController: MediaPickerManagerDelegate {
    
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage) {
        
        // Instance of EAGLContext 
        let eaglContext = EAGLContext(API: .OpenGLES2)
        
        // Instance of CIContext
        
        let ciContext = CIContext(EAGLContext: eaglContext) 
        
        // Instance of PhotoFilterController with the image the user selected 
        
        let photoFilterController = PhotoFilterController(image: image, context: ciContext, eaglContext: eaglContext) 
        
        // Embed photoFilterController in navigation controller 
        
        let navigationController = UINavigationController(rootViewController: photoFilterController)
        
        // Dismiss image picker and present navigation controller 
        
        manager.dismissImagePickerController(animated: true) {
            self.presentViewController(navigationController, animated: true, completion: nil) 
        }
    }
}

