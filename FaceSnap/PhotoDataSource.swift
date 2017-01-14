//
//  PhotoDataSource.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/13/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class PhotoDataSource: NSObject {
    
    // Create collection view. 
    
    private let collectionView: UICollectionView
    
    // Create managed object context. 
    
    private let managedObjectContext = CoreDataController.sharedInstance.managedObjectContext
    
    // Create fetched results controller.
    
    private let fetchedResultsController: PhotoFetchedResultsController
    
    init(fetchRequest: NSFetchRequest, collectionView: UICollectionView) {
        self.collectionView = collectionView
        
        self.fetchedResultsController = PhotoFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, collectionView: self.collectionView)
        
        super.init()
    }
}

// MARK: - UICollectionViewDataSource

extension PhotoDataSource: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        
        return section.numberOfObjects
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        // Retrieve cell.
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PhotoCell.reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        
        // Retrieve photo. 
        
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        
        cell.imageView.image = photo.photoImage
        
        return cell 
    }
}