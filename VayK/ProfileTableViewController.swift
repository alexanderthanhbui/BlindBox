//
//  ProfileTableViewController.swift
//  VayK
//
//  Created by Hayne Park on 6/29/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileTableViewController: UITableViewController {
    
    let model = generateRandomData()
    var storedOffsets = [Int: CGFloat]()
    
    override func viewDidLoad() {
        let userObjectID = PFUser.currentUser()!.objectId!
        let query2 = PFQuery(className:"_User")
        query2.getObjectInBackgroundWithId(userObjectID) {
            (gameScore: PFObject?, var error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let gameScore = gameScore {
                let userImageFile = gameScore["UserImage"] as! PFFile
                let firstName = gameScore["FirstName"] as! String
                let userBirthday = gameScore["Birthday"] as! String
                print("it worked")
                
                
                
                // Convert String to NSDate
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd-yyy"
                let date = dateFormatter.dateFromString(userBirthday as String)
                let birthday: NSDate = date!
                var now: NSDate = NSDate()
                var ageComponents: NSDateComponents = NSCalendar.currentCalendar().components(.Year, fromDate: birthday, toDate: now, options: [])
                var age: Int = ageComponents.year
                
               /* userImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            //self.userImage.image = image

                        }
                    }
                }*/
            }
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 355
        }
        if indexPath.row == 1
        {
            return 135
        }
        let height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        return height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("firstCustomCell",
                forIndexPath: indexPath) as! ProfileFirstCustomTableViewCell
            //set the data here
            let userObjectID = PFUser.currentUser()!.objectId!
            let query2 = PFQuery(className:"_User")
            query2.getObjectInBackgroundWithId(userObjectID) {
                (gameScore: PFObject?, var error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let gameScore = gameScore {
                    let userImageFile = gameScore["UserImage"] as! PFFile
                    userImageFile.getDataInBackgroundWithBlock {
                    (imageData: NSData?, error: NSError?) -> Void in
                    if error == nil {
                    if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    cell.userImage.image = image
                    }
                    }
                    }
                }
            }
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("secondCustomCell",
                forIndexPath: indexPath) as! ProfileSecondCustomTableViewCell
                //set the data here
            let userObjectID = PFUser.currentUser()!.objectId!
            let query2 = PFQuery(className:"_User")
            query2.getObjectInBackgroundWithId(userObjectID) {
                (gameScore: PFObject?, var error: NSError?) -> Void in
                if error != nil {
                    print(error)
                } else if let gameScore = gameScore {
                    let firstName = gameScore["FirstName"] as! String
                    let userBirthday = gameScore["Birthday"] as! String

                    // Convert String to NSDate
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM-dd-yyy"
                    let date = dateFormatter.dateFromString(userBirthday as String)
                    let birthday: NSDate = date!
                    var now: NSDate = NSDate()
                    var ageComponents: NSDateComponents = NSCalendar.currentCalendar().components(.Year, fromDate: birthday, toDate: now, options: [])
                    var age: Int = ageComponents.year
                    cell.nameLabel.text = ("\(firstName), \(age)")
                }
            }
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        return cell
    }
    

}
