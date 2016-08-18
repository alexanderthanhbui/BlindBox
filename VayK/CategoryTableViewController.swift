//
//  CategoryTableViewController.swift
//  VayK
//
//  Created by Hayne Park on 8/1/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    var categoryNames = ["Arts", "Classes", "Education", "Food & Drinks", "Misc.", "Music", "Networking", "Social", "Sports"]

    
    var genderIsPicked = [Bool](count: 9, repeatedValue: false)
    
    var lastSelection: NSIndexPath!
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int {
            return categoryNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Category"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
            forIndexPath: indexPath) as! CategoryCreateTableViewCell
        // Configure the cell...
        cell.categoryLabel.text = categoryNames[indexPath.row]
        let checkMarkToDisplay = NSUserDefaults.standardUserDefaults().integerForKey("categoryLastSelection")
        if checkMarkToDisplay == indexPath.row{
            cell.accessoryType = .Checkmark
        }
        else{
            cell.accessoryType = .None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let numberOfRows = tableView.numberOfRowsInSection(section)
        for row in 0..<numberOfRows {
            if let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: row, inSection: section)) {
                cell.accessoryType = row == indexPath.row ? .Checkmark : .None
            }
        }
        NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "categoryLastSelection")
        NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "createCategory")
    }
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .None
        self.genderIsPicked[indexPath.row] = false
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
}
