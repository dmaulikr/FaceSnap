//
//  Photo.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/10/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CoreLocation

class Photo: NSManagedObject {
    
    static let entityName = "\(Photo.self)"
    
    static var allPhotosRequest: NSFetchRequest = {
        
        // Create request
        
        let request = NSFetchRequest(entityName: Photo.entityName)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request 
    }()
    
    // Class method that displays just photo and date
    
    class func photo(withImage image: UIImage) -> Photo {
        
        // Create instance of photo.
        
        let photo = NSEntityDescription.insertNewObjectForEntityForName(Photo.entityName, inManagedObjectContext: CoreDataController.sharedInstance.managedObjectContext) as! Photo
        
        // Assign values to the instance.
        
        photo.date = NSDate().timeIntervalSince1970
        
        // Convert UIImage instance to NSImage instance.
        
        photo.image = UIImageJPEGRepresentation(image, 1.0)!
        
        return photo
        
    }
    
    // Class method to add location and tags to photo. 
    
    class func photoWith(image: UIImage, tags: [String], location: CLLocation?) {
        
        let photo = Photo.photo(withImage: image)
        photo.addTags(tags)
        photo.addLocation(location)
    }
    
    // Helper method to add single tag to a photo. 
    
    func addTag(withTitle title: String) {
        
        // Create instance of tag object.
        
        let tag = Tag.tag(withTitle: title)
        tags.insert(tag)
    }
    
    // Helper method to add array of tags. 
    
    func addTags(tags: [String]) {
        
        for tag in tags {
            addTag(withTitle: tag)
        }
    }
    
    // Helper method to add location. 
    
    func addLocation(location: CLLocation?) {
        
        if let location = location {
            let photoLocation = Location.locationWith(location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            // Add to location property on photo. 
            
            self.location = photoLocation
        }
    }
    
    

    
}

extension Photo {
    
    // Date property
    
    @NSManaged var date: NSTimeInterval
    
    // Image property
    
    @NSManaged var image: NSData
    
    // Tag property
    
    @NSManaged var tags: Set<Tag>
    
    // Location property
    
    @NSManaged var location: Location?
    
    var photoImage: UIImage {
        return UIImage(data: image)! 
    }
}
