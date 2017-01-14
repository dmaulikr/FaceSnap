//
//  PhotoMetadataController.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/8/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import UIKit
import CoreLocation

class PhotoMetadataController: UITableViewController {
    
    private let photo: UIImage
    
    init(photo: UIImage) {
        self.photo = photo
        
        super.init(style: .Grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Metadata Fields 
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView(image: self.photo)
        imageView.contentMode = .ScaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //Property to calculate imageViewHeight
   
    private lazy var imageViewHeight: CGFloat = {
        
        let imgFactor = self.photoImageView.frame.size.height/self.photoImageView.frame.size.width
        
        // Determine width of screen that table view is housed in. 
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        
        return screenWidth * imgFactor
    }()
    
    // Place holder label for location. 
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to add location"
        label.textColor = .lightGrayColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Activity Indicator
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.hidden = true
        return view
    }()
    
    // Location Manager
    
    private var locationManager: LocationManager!
   
    // Property to hang onto location.
    
    private var location: CLLocation?
    
    // tagsTextField stored property
    
    private lazy var tagsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "summer, vacation"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Save button for saving photo
        
        let saveButton = UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: #selector(PhotoMetadataController.savePhotoWithMetadata))
        navigationItem.rightBarButtonItem = saveButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension PhotoMetadataController {

// MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Instance of UITableViewCell
        
        let cell = UITableViewCell()
        cell.selectionStyle = .None
        
        switch (indexPath.section, indexPath.row) {
            
        // Cell that displays photo
        
        case (0, 0):
            
            // Layout Code for photoImageView
            cell.contentView.addSubview(photoImageView)
            
            NSLayoutConstraint.activateConstraints([
                photoImageView.topAnchor.constraintEqualToAnchor(cell.contentView.topAnchor),
                photoImageView.rightAnchor.constraintEqualToAnchor(cell.contentView.rightAnchor),
                photoImageView.bottomAnchor.constraintEqualToAnchor(cell.contentView.bottomAnchor),
                photoImageView.leftAnchor.constraintEqualToAnchor(cell.contentView.leftAnchor)
            ])
            
        // Cell that displays location 
       
        case (1,0):
            cell.contentView.addSubview(locationLabel)
            cell.contentView.addSubview(activityIndicator)

            NSLayoutConstraint.activateConstraints([
                activityIndicator.centerYAnchor.constraintEqualToAnchor(cell.contentView.centerYAnchor),
                activityIndicator.leftAnchor.constraintEqualToAnchor(cell.contentView.leftAnchor, constant: 20.0),
                locationLabel.topAnchor.constraintEqualToAnchor(cell.contentView.topAnchor),
                locationLabel.rightAnchor.constraintEqualToAnchor(cell.contentView.rightAnchor, constant: 16.0),
                locationLabel.bottomAnchor.constraintEqualToAnchor(cell.contentView.bottomAnchor),
                locationLabel.leftAnchor.constraintEqualToAnchor(cell.contentView.leftAnchor, constant: 20.0)
            ])
            
        // Cell that displays metadata
            
        case (2,0):
            cell.contentView.addSubview(tagsTextField)
            
            NSLayoutConstraint.activateConstraints([
                tagsTextField.topAnchor.constraintEqualToAnchor(cell.contentView.topAnchor),
                tagsTextField.rightAnchor.constraintEqualToAnchor(cell.contentView.rightAnchor, constant: 16.0),
                tagsTextField.bottomAnchor.constraintEqualToAnchor(cell.contentView.bottomAnchor),
                tagsTextField.leftAnchor.constraintEqualToAnchor(cell.contentView.leftAnchor, constant: 20.0)
            ])
            
            
        default: break
        }
        
        return cell
    }
}

// MARK: - Helper Methods

extension PhotoMetadataController {
    
    func tagsFromTextField() -> [String] {
        guard let tags = tagsTextField.text else { return [] }
        
        // Separate tags by separating every comma.
        
        let commaSeparatedSubSequences = tags.characters.split { $0 == "," }
        
        // Create comma separated strings by mapping over the comma separated subsequences array, and using the strings init method. 
        
        let commaSeparatedStrings = commaSeparatedSubSequences.map(String.init)
        
        // Save all tags as lowercase
        
        let lowercaseTags = commaSeparatedStrings.map { $0.lowercaseString }
        
        return lowercaseTags.map { $0.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) }
    }
}

// MARK: - Persistence

extension PhotoMetadataController {
    
    @objc private func savePhotoWithMetadata() {
        
        let tags = tagsFromTextField()
        Photo.photoWith(photo, tags: tags, location: location)
        
        // Save changes in the context.
        
        CoreDataController.save()
        dismissViewControllerAnimated(true, completion: nil) 
        
    }
}

// MARK: - UITableViewDelegate

extension PhotoMetadataController {
    
    // Method to set row heights
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        switch (indexPath.section, indexPath.row) {
            
        //Row that contains imageView
        case (0, 0): return imageViewHeight
        
        //For two other rows
        default: return tableView.rowHeight
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            
            // Hide location label.
            locationLabel.hidden = true
            activityIndicator.hidden = false
            activityIndicator.startAnimating()
            
            // Create instance of property LocationManager()
            
            locationManager = LocationManager()
            locationManager.onLocationFix = { placemark, error in
                if let placemark = placemark {
                    self.location = placemark.location
                    
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.hidden = true
                    self.locationLabel.hidden = false
                    
                    // Create location string using information in placemark object.
                    
                    guard let name = placemark.name, city = placemark.locality, area = placemark.administrativeArea else { return }
                    
                    self.locationLabel.text = "\(name), \(city), \(area)"
                        
                    }
                    
                }
        default: break
        }
            
    }
    
    // Method to add header property to each section.
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Photo"
        case 1: return "Enter a location"
        case 2: return "Enter tags"
        default: return nil
        }
    }
}
