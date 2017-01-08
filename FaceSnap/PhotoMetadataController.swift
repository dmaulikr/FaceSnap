//
//  PhotoMetadataController.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/8/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import UIKit

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

    override func viewDidLoad() {
        super.viewDidLoad()
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
            
        default: break
        }
        
        return cell
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
}
