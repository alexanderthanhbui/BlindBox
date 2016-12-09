//
//  ProfileTableViewController.swift
//  VayK
//
//  Created by Hayne Park on 6/29/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileTableViewController: UITableViewController {
    
    @IBAction func unwindToProfile(_ segue: UIStoryboardSegue) {}
    
    let model = generateRandomData()
    var storedOffsets = [Int: CGFloat]()
    var groupId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath as NSIndexPath).row == 0
        {
            return 355
        }
        let height = super.tableView(tableView, heightForRowAt: indexPath)
        return height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstCustomCell",
                for: indexPath) as! ProfileFirstCustomTableViewCell
            //set the data here
            let userObjectID = PFUser.current()!.objectId!
            let query2 = PFQuery(className:"_User")
            query2.getObjectInBackground(withId: userObjectID) {
                (gameScore: PFObject?, error: Error?) -> Void in
                if error != nil {
                    print(error)
                } else if let gameScore = gameScore {
                    let userImageFile = gameScore["userImage"] as! PFFile
                    userImageFile.getDataInBackground {
                    (imageData: Data?, error: Error?) -> Void in
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
        if (indexPath as NSIndexPath).row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondCustomCell",
                for: indexPath) as! ProfileSecondCustomTableViewCell
            
            //set the data here
            let user = PFUser.current()
            let firstName = user![PF_USER_FIRSTNAME] as! String
            let userBirthday = user![PF_USER_BIRTHDAY] as! String
            if (user![PF_USER_BIO] != nil) && (user![PF_USER_WEBSITE] != nil) {
                let bio = user![PF_USER_BIO] as! String
                let website = user![PF_USER_WEBSITE] as! String

                cell.infoTextView.text = bio + "\n" + website
            }
            if (user![PF_USER_BIO] != nil) && (user![PF_USER_WEBSITE] == nil) {
                let bio = user![PF_USER_BIO] as! String
                cell.infoTextView.text = bio
            }
            if (user![PF_USER_BIO] == nil) && (user![PF_USER_WEBSITE] != nil) {
                let website = user![PF_USER_WEBSITE] as! String
                
                cell.infoTextView.text = website
            }
            // Convert String to NSDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyy"
            let date = dateFormatter.date(from: userBirthday as String)
            let birthday: Date = date!
            var now: Date = Date()
            var ageComponents: DateComponents = (Calendar.current as NSCalendar).components(.year, from: birthday, to: now, options: [])
            var age: Int = ageComponents.year!
            cell.nameLabel.text = ("\(firstName), \(age)")

            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
}
