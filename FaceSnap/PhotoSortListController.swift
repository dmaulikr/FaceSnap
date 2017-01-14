//
//  PhotoSortListController.swift
//  FaceSnap
//
//  Created by Robert Berry on 1/14/17.
//  Copyright © 2017 Robert Berry. All rights reserved.
//

import UIKit
import CoreData

class PhotoSortListController<SortType: CustomTitleConvertible where SortType: NSManagedObject>: UITableViewController {
    
    // Property to hold onto data source. 
    
    let dataSource: SortableDataSource<SortType>
    
    // Property to hold onto sort item selector. 
    
    let sortItemSelector: SortItemSelector<SortType>
    
    var onSortSelection: (Set<SortType> -> Void)?
    
    init(dataSource: SortableDataSource<SortType>, sortItemSelector: SortItemSelector<SortType>) {
        self.dataSource = dataSource
        self.sortItemSelector = sortItemSelector
        super.init(style: .Grouped)
       
        tableView.dataSource = dataSource
        tableView.delegate = sortItemSelector 
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation() 

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupNavigation() {
        
        // Create done button
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: #selector(PhotoSortListController.dismissPhotoSortListController))
        
        navigationItem.rightBarButtonItem = doneButton
        
    }
    
    // Method to dismiss PhotoSortListController
    
    @objc private func dismissPhotoSortListController() {
        
        // Verify closure isn't nil.
        
        guard let onSortSelection = onSortSelection else { return }
        onSortSelection(sortItemSelector.checkedItems) 
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}


