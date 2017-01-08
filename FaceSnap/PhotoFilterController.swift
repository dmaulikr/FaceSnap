//
//  PhotoFilterController.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/7/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import UIKit

class PhotoFilterController: UIViewController {
    
    // Image user previously selected 
    
    private var mainImage: UIImage {
        
        // Property Observer: When image is set to a new value, assign new image to photoImageView
        
        didSet {
            photoImageView.image = mainImage
        }
    }
    private let context: CIContext
    private let eaglContext: EAGLContext
    
    // Photo Image View
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .ScaleAspectFit
        return imageView
    }()
    
    // Filter Header Label
    private lazy var filterHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "Select a filter"
        label.textAlignment = .Center
        return label
    }()
    
    // Collection View to display images with filters applied 
    
    lazy var filtersCollectionView: UICollectionView = {
        
        // Instance of UICollectionViewFlowLayout
        let flowLayout = UICollectionViewFlowLayout()
        
        // Scroll Direction
        flowLayout.scrollDirection = .Horizontal
        
        // Space each item a minimum of 10 points from each other 
        flowLayout.minimumLineSpacing = 10
        
        //minimumInteritemSpacing takes value to determine how many items can fit on a single line
        flowLayout.minimumInteritemSpacing = 1000
        
        // Each object to have a width and height pf 100 points
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        
        // Create new UICollectionView
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .whiteColor()
        
        //Register cell for collection view use
        collectionView.registerClass(FilteredImageCell.self, forCellWithReuseIdentifier: FilteredImageCell.reuseIdentifier)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    // Provide array of images that we get back in filtered image builder 
    
    private lazy var filteredImages: [CIImage] = {
        // Call instance of filtered image builder class
        let filteredImageBuilder = FilteredImageBuilder(context: self.context, image: self.mainImage)
        return filteredImageBuilder.imageWithDefaultFilters()
    }()
    
    init(image: UIImage, context: CIContext, eaglContext: EAGLContext) {
        
        // Assign image to mainImage
        self.mainImage = image
        self.context = context
        self.eaglContext = eaglContext 
        
        self.photoImageView.image = self.mainImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Button that calls dismissPhotoFilterController method via target action 
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: #selector(PhotoFilterController.dismissPhotoFilterController))
        navigationItem.leftBarButtonItem = cancelButton
        
        // Button that calls presentMetadataController method via target action
        let nextButton = UIBarButtonItem(title: "Next", style: .Plain, target: self, action: #selector(PhotoFilterController.presentMetadataController))
        navigationItem.rightBarButtonItem = nextButton
        
    }

    // Layout Code
    override func viewWillLayoutSubviews() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(photoImageView)
        
        filterHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterHeaderLabel)
        
        filtersCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filtersCollectionView)
        
        NSLayoutConstraint.activateConstraints([
            filtersCollectionView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor),
            filtersCollectionView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            filtersCollectionView.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            filtersCollectionView.heightAnchor.constraintEqualToConstant(200.0),
            filtersCollectionView.topAnchor.constraintEqualToAnchor(filterHeaderLabel.bottomAnchor),
            filterHeaderLabel.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            filterHeaderLabel.rightAnchor.constraintEqualToAnchor(view.rightAnchor),
            photoImageView.bottomAnchor.constraintEqualToAnchor(filtersCollectionView.topAnchor),
            photoImageView.topAnchor.constraintEqualToAnchor(view.topAnchor),
            photoImageView.leftAnchor.constraintEqualToAnchor(view.leftAnchor),
            photoImageView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        ])
    }

}

// MARK: - UICollectionViewDataSource

extension PhotoFilterController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // Return number of filtered images
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(FilteredImageCell.reuseIdentifier, forIndexPath: indexPath) as! FilteredImageCell
        
        // Image we retrieve from data source
        let ciImage = filteredImages[indexPath.row]
        
        cell.ciContext = context
        cell.eaglContext = eaglContext
        cell.image = ciImage
        
        return cell 
    }
}

// MARK: - UICollectionViewDelegate 
extension PhotoFilterController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        // Retrieve image we selected 
        let ciImage = filteredImages[indexPath.row]
        
        // Draw CGImage in the bounds of the CIImage
        let cgImage = context.createCGImage(ciImage, fromRect: ciImage.extent)
        
        mainImage = UIImage(CGImage: cgImage)
    }
}

// MARK: - Navigation 

extension PhotoFilterController {
    
    // Method to add button that will cancel the photo you selected. 
    
    @objc private func dismissPhotoFilterController() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Method to add button that will allow user to add information to selected photo. 
    
    @objc private func presentMetadataController() {
        
    }
}

