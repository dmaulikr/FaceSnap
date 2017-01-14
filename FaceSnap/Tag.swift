//
//  Tag.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/10/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import Foundation
import CoreData

class Tag: NSManagedObject {
    
    static let entityName = "\(Tag.self)"
    
    // Class method to return instance of tag given a title.
    
    class func tag(withTitle title: String) -> Tag {
        let tag = NSEntityDescription.insertNewObjectForEntityForName(Tag.entityName, inManagedObjectContext: CoreDataController.sharedInstance.managedObjectContext) as! Tag
        
        // Assign values to the instance.
        
        tag.title = title
        
        return tag
    }

}

extension Tag {
    
    // Title property
    
    @NSManaged var title: String 
}
