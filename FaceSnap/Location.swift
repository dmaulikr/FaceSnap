//
//  Location.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/10/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import Foundation
import CoreData

class Location: NSManagedObject {
    
    static let entityName = "\(Location.self)"
    
    // Class method to create location object. 
    
    class func locationWith(latitude: Double, longitude: Double) -> Location {
        
        // Create location object 
        
        let location = NSEntityDescription.insertNewObjectForEntityForName(Location.entityName, inManagedObjectContext: CoreDataController.sharedInstance.managedObjectContext) as! Location
        
        // Assign values to the instance.
        
        location.latitude = latitude
        location.longitude = longitude
        
        return location
    
    }
}

extension Location {
    
    // Latitude and longitude properties 
    
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double 
} 
