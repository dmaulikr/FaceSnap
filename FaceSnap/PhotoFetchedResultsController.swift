//
//  PhotoFetchedResultsController.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/13/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import UIKit
import CoreData

class PhotoFetchedResultsController: NSFetchedResultsController, NSFetchedResultsControllerDelegate {
    
    private let collectionView: UICollectionView
    
    init(fetchRequest: NSFetchRequest, managedObjectContext: NSManagedObjectContext, collectionView: UICollectionView) {
        
        self.collectionView = collectionView
        
        super.init(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        self.delegate = self
        
        executeFetch()
    }
    
    // Method to fetch data after fetch request. 
    
    func executeFetch() {
        do {
            try performFetch()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate 
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        collectionView.reloadData() 
    }

}
