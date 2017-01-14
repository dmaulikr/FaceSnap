//
//  SortItemSelector.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/14/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import Foundation
import UIKit
import CoreData

// Class will act as delegate to sort list controller table view. 

class SortItemSelector<SortType: NSManagedObject>: NSObject, UITableViewDelegate {
    
    private let sortItems: [SortType]
    
    // Set property to store checked items. 
    
    var checkedItems: Set<SortType> = []
    
    init(sortItems: [SortType]) {
        self.sortItems = sortItems
        super.init()
    }
    
    // MARK: - UITableViewDelegate
    
    // Method called when we select row in table view.
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 0:
            
            guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return }
            
            // If all tags cell wasn't checked before.
        
            if cell.accessoryType == .None {
                
                // Check cell and display check mark. 
                cell.accessoryType = .Checkmark
                
                // Remove all check marks for tags in second section. 
                
                // Create property to move to next section. In our case this will move to section with individual tags.
                
                let nextSection = indexPath.section.advancedBy(1)
                
                // Create property to determine number of rows in section. 
                
                let numberOfRowsInSubsequentSection = tableView.numberOfRowsInSection(nextSection)
                
                // Create loop to iterate through rows in second section. The second section has individual tags. 
                
                for row in 0..<numberOfRowsInSubsequentSection {
                    let indexPath = NSIndexPath(forRow: row, inSection: nextSection)
                    
                    // Remove checkmark from each individual row in second section. This will remove all checkmarks from individual tags.
                    
                    let cell = tableView.cellForRowAtIndexPath(indexPath)
                    cell?.accessoryType = .None
                    
                    // Reset checked items section to empty. 
                    
                    checkedItems = []
                }
            }
            
        case 1:
            
            // Remove check mark from all items cell, and add checkmark to highlighted items cell. 
            
            // Retrieve indexPath for All Tags section.
            
            let allItemsIndexPath = NSIndexPath(forRow: 0, inSection: 0)
            
            // Retrieve cell for all tags section.
            
            let allItemsCell = tableView.cellForRowAtIndexPath(allItemsIndexPath)
            
            // Remove check mark from all items cell. 
            
            allItemsCell?.accessoryType = .None
            
            // Retrieve current cell. 
            
            guard let cell = tableView.cellForRowAtIndexPath(indexPath) else { return }
            
            // Retrieve cell with individual tag.
            
            let item = sortItems[indexPath.row]
            
            // Toggle check mark. 
            
            if cell.accessoryType == .None {
                cell.accessoryType = .Checkmark
                checkedItems.insert(item)
            } else if cell.accessoryType == .Checkmark {
                cell.accessoryType = .None
                checkedItems.remove(item)
            }
        default: break
        }
        
        print(checkedItems.description)
    
    }
} 
