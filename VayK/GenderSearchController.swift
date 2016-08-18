//
//  GenderSearchController.swift
//  VayK
//
//  Created by Hayne Park on 3/31/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import Foundation

class GenderSearchController : UITableViewController {
    
    var genderNames = ["Only Men", "Only Women", "Men and Women"]
    
    var genderIsPicked = [Bool](count: 3, repeatedValue: false)
    
    var lastSelection: NSIndexPath!
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int {
        return genderNames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cellIdentifier = "Gender"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier,
            forIndexPath: indexPath) as! GenderSearchTableViewCell
            // Configure the cell...
            cell.genderLabel.text = genderNames[indexPath.row]
        let checkMarkToDisplay = NSUserDefaults.standardUserDefaults().integerForKey("lastSelection") 
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
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "lastSelection")
            NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "Gender")
    }
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = .None
        self.genderIsPicked[indexPath.row] = false
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
}