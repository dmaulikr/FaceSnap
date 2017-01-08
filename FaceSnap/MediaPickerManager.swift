//
//  MediaPickerManager.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/7/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import UIKit
import MobileCoreServices

protocol MediaPickerManagerDelegate: class {
    
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage)
}

class MediaPickerManager: NSObject {
    
    // Create instance of UIImagePickerController as stored property 
    
    private let imagePickerController = UIImagePickerController()
    
    // Private stored property to maintain reference to view controller. 
    
    private let presentingViewController: UIViewController
    
    weak var delegate: MediaPickerManagerDelegate?
    
    
    init(presentingViewController: UIViewController) {
        self.presentingViewController = presentingViewController
        super.init()
        
        imagePickerController.delegate = self
        
        // Set instance of UIImagePickerController as a camera 
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            imagePickerController.sourceType = .Camera
            
            // Instance of UIImagePickerController launches with front camera on to enable selfies. 
            
            imagePickerController.cameraDevice = .Front
        } else {
            imagePickerController.sourceType = .PhotoLibrary
        }
        
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
    
    // Method to present image picker 
    
    func presentImagePickerController(animated animated: Bool) {
        presentingViewController.presentViewController(imagePickerController, animated: animated, completion: nil)
    }
    
    // Provide method for API image dismissal 
    
    func dismissImagePickerController(animated animated: Bool, completion: (() -> Void)) {
        imagePickerController.dismissViewControllerAnimated(animated, completion: completion)
    }

}

extension MediaPickerManager: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // Method that notifies us when a user picked an image, and also lets us know if a movie was picked. 
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // Grab image selected by user 
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        delegate?.mediaPickerManager(self, didFinishPickingImage: image) 
    }
}
