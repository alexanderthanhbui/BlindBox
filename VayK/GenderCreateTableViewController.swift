//
//  GenderCreateTableViewController.swift
//  VayK
//
//  Created by Hayne Park on 7/29/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit

class GenderCreateTableViewController: UITableViewController {

    var genderNames = ["Only Men", "Only Women", "Men and Women"]
    
    var genderIsPicked = [Bool](repeating: false, count: 3)
    
    var lastSelection: IndexPath!
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int {
            return genderNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Gender"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
            for: indexPath) as! GenderCreateTableViewCell
        // Configure the cell...
        cell.genderLabel.text = genderNames[(indexPath as NSIndexPath).row]
        let checkMarkToDisplay = UserDefaults.standard.integer(forKey: "createLastSelection")
        if checkMarkToDisplay == (indexPath as NSIndexPath).row{
            cell.accessoryType = .checkmark
        }
        else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = (indexPath as NSIndexPath).section
        let numberOfRows = tableView.numberOfRows(inSection: section)
        for row in 0..<numberOfRows {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) {
                cell.accessoryType = row == (indexPath as NSIndexPath).row ? .checkmark : .none
            }
        }
        UserDefaults.standard.set((indexPath as NSIndexPath).row, forKey: "createLastSelection")
        UserDefaults.standard.set((indexPath as NSIndexPath).row, forKey: "createGender")
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        self.genderIsPicked[(indexPath as NSIndexPath).row] = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
}
