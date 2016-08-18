//
//  AddRestaurantController.swift
//  VayK
//
//  Created by Hayne Park on 4/21/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit

class EditTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var nameLabel:UILabel!
    
    var nameData: String!
    var image: PFFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
      }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 70
        }
        if indexPath.row == 1
        {
            return 44
        }
        if indexPath.row == 2
        {
            return 44
        }
        let height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        return height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("firstCustomCell",
                forIndexPath: indexPath) as! EditProfileFirstCustomTableViewCell
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
                                cell.userImage.layer.cornerRadius = 25.0
                                cell.userImage.clipsToBounds = true
                            }
                        }
                    }
                }
            }
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("secondCustomCell",
                forIndexPath: indexPath) as! EditProfileSecondCustomTableViewCell
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
                    cell.nameImage.image = cell.nameImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                    cell.nameImage.tintColor = UIColor.lightGrayColor()
                }
            }
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("thirdCustomCell",
            forIndexPath: indexPath) as! EditProfileThirdCustomTableViewCell
            cell.websiteImage.image = cell.websiteImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.websiteImage.tintColor = UIColor.lightGrayColor()
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! EditProfileBioCustomTableViewCell
            cell.textView.delegate = self
            cell.infoPlaceHolder = UILabel()
            cell.infoPlaceHolder.text = "Bio"
            cell.infoPlaceHolder.font = UIFont.systemFontOfSize(cell.textView.font!.pointSize)
            cell.infoPlaceHolder.sizeToFit()
            cell.textView.addSubview(cell.infoPlaceHolder)
            cell.infoPlaceHolder.frame.origin = CGPointMake(5, cell.textView.font!.pointSize / 2)
            cell.infoPlaceHolder.textColor = UIColor(white: 0, alpha: 0.3)
            cell.infoPlaceHolder.hidden = !cell.textView.text.isEmpty

            cell.infoImage.image = cell.infoImage.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            cell.infoImage.tintColor = UIColor.lightGrayColor()

            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        
        return cell
    }

}

extension EditTableViewController: UITextViewDelegate {
    
    func textViewDidChange(textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
    }
}