//
//  LocationManager.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/8/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    
    let manager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var onLocationFix: ((CLPlacemark?, NSError?) -> Void)?
    
    // Request permission to get user's location 
    
    override init() {
        super.init()
        manager.delegate = self
        getPermission()
    }
    
    // Determine if authorization status has been requested yet, and if it hasn't request authorization.
    
    private func getPermission() {
        if CLLocationManager.authorizationStatus() == .NotDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }

}

extension LocationManager: CLLocationManagerDelegate {
    
    // Method called when there is a change in authorization status. 
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            manager.requestLocation()
        }
    }
    
    // Method for responding to errors
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Unresolved error \(error), \(error.userInfo)")
    }
    
    // Method called when we receive location update.
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // Reverse geocode location
        geoCoder.reverseGeocodeLocation(location) { placemarks, error in
            if let onLocationFix = self.onLocationFix {
                onLocationFix(placemarks?.first, error)
            }
        }
        
    }
}
