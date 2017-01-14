//
//  SortableDataSource.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/14/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Declare new protocol CustomTitleConvertible

protocol CustomTitleConvertible {
    
    // Types that conform must display title as string. 
    
    var title: String { get }
}

// Tag now conforms to this protocol.

extension Tag: CustomTitleConvertible {}

// Generic class over a particular type.

class SortableDataSource<SortType: CustomTitleConvertible where SortType: NSManagedObject>: NSObject, UITableViewDataSource {
    
    // Create fetchedResultsController
    
    private let fetchedResultsController: NSFetchedResultsController
    
    var results: [SortType] {
        return fetchedResultsController.fetchedObjects as! [SortType] 
    }
    
    init(fetchRequest: NSFetchRequest, managedObjectContext moc: NSManagedObjectContext) {
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        
        super.init()
        
        executeFetch()
    }
    
    // Execute fetch method. 
    
    func executeFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            
        // Section 0 is the all tags section.
        
        case 0: return 1
            
        // Section 1 is the tags returned from fetchedResultsController. 
            
        case 1: return fetchedResultsController.fetchedObjects?.count ?? 0
        default: return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Create instance of UITableViewCell 
        
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "sortableItemCell")
        cell.selectionStyle = .None
        
        // Switch on index path section and row. 
        
        switch (indexPath.section, indexPath.row) {
        case (0,0):
            cell.textLabel?.text = "All \(SortType.self)s"
            cell.accessoryType = .Checkmark
            
        // case (1,_) refers to section 1, any row (Start counting at section 0)
            
        case (1,_):
            
            guard let sortItem = fetchedResultsController.fetchedObjects?[indexPath.row] as? SortType else {
                break
            }
            
            cell.textLabel?.text = sortItem.title
        default: break 
            
        }
        
        return cell
        
    }
}


