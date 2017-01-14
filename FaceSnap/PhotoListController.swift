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
    
    // Create instance of PhotoDataSource, so that are photos have a data source.
    
    lazy var dataSource: PhotoDataSource = {
        return PhotoDataSource(fetchRequest: Photo.allPhotosRequest, collectionView: self.collectionView)
    }()
    
    // Create collection view flow layout.
    
    lazy var collectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let paddingDistance: CGFloat = 16.0
        let itemSize = (screenWidth - paddingDistance)/2.0
        
        collectionViewLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .whiteColor()
        collectionView.registerClass(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.reuseIdentifier)
        
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        
        collectionView.dataSource = dataSource
        self.automaticallyAdjustsScrollViewInsets = false 
    }
    
    // MARK: - Layout
    
    override func viewWillLayoutSubviews() {
        
        // Add collection view as a subview. 
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false 
        
        // Camera Button Layout
        
        view.addSubview(cameraButton)
        cameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activateConstraints([
            
            // Layout Code
            collectionView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            collectionView.topAnchor.constraintEqualToAnchor(topLayoutGuide.bottomAnchor),
            collectionView.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            collectionView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
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

// MARK: - Navigation 

extension PhotoListController {
    
    // Set up method to set buttons up. 
    
    private func setupNavigationBar() {
        
        // Create a bar button item. 
        
        let sortTagsButton = UIBarButtonItem(title: "Tags", style: .Plain, target: self, action: #selector(PhotoListController.presentSortController))
        
        // Method that takes array of buttons. 
        
        navigationItem.setRightBarButtonItems([sortTagsButton], animated: true)
    }
    
    @objc private func presentSortController() {
        
        // Create tags data source
        
        let tagDataSource = SortableDataSource<Tag>(fetchRequest: Tag.allTagsRequest, managedObjectContext: CoreDataController.sharedInstance.managedObjectContext)
        
        // Create instance of sortItemSelector. 
        
        let sortItemSelector = SortItemSelector(sortItems: tagDataSource.results)
        
        // Create sort controller
        
        let sortController = PhotoSortListController(dataSource: tagDataSource, sortItemSelector: sortItemSelector) 
        
        // Create navigation controller. 
        
        let navigationController = UINavigationController(rootViewController: sortController)
        
        presentViewController(navigationController, animated: true, completion: nil) 
        
    }
}

