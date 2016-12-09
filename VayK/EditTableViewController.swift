//
//  AddRestaurantController.swift
//  VayK
//
//  Created by Hayne Park on 11/28/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit

class EditTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var nameLabel:UILabel!

    var nameData: String!
    var image = UIImage()
    var infoPlaceHolder : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let userObjectID = PFUser.current()!.objectId!
        let query2 = PFQuery(className:"_User")
        query2.getObjectInBackground(withId: userObjectID) {
            (gameScore: PFObject?, error: Error?) -> Void in
            if error != nil {
                print(error)
            } else if let gameScore = gameScore {
                let image = gameScore["userImage"] as! PFFile
                image.getDataInBackground {
                    (imageData: Data?, error: Error?) -> Void in
                    if error == nil {
                        if let imageData = imageData {
                            self.image = UIImage(data:imageData)!
                            self.tableView.reloadData()
                        }
                    }
                }

            }
        }
      }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if (indexPath as NSIndexPath).row == 0
        {
            return 70
        }
        if (indexPath as NSIndexPath).row == 1
        {
            return 44
        }
        if (indexPath as NSIndexPath).row == 2
        {
            return 44
        }
        let height = super.tableView(tableView, heightForRowAt: indexPath)
        return height
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstCustomCell",
                for: indexPath) as! EditProfileFirstCustomTableViewCell
            //set the data here
            cell.userImage.image = image
            cell.userImage.layer.cornerRadius = 25.0
            cell.userImage.clipsToBounds = true


            return cell
        }
        if (indexPath as NSIndexPath).row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondCustomCell",
                for: indexPath) as! EditProfileSecondCustomTableViewCell
            //set the data here
            cell.nameImage.image = cell.nameImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.nameImage.tintColor = UIColor.lightGray
            let user = PFUser.current()
            let firstName = user![PF_USER_FIRSTNAME] as! String
            let userBirthday = user![PF_USER_BIRTHDAY] as! String

            // Convert String to NSDate
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyy"
            let date = dateFormatter.date(from: userBirthday as String)
            let birthday: Date = date!
            let now: Date = Date()
            let ageComponents: DateComponents = (Calendar.current as NSCalendar).components(.year, from: birthday, to: now, options: [])
            let age: Int = ageComponents.year!
            cell.nameLabel.text = ("\(firstName), \(age)")

            return cell
        }
        if (indexPath as NSIndexPath).row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "thirdCustomCell",
            for: indexPath) as! EditProfileThirdCustomTableViewCell
            cell.websiteImage.image = cell.websiteImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.websiteImage.tintColor = UIColor.lightGray
            let user = PFUser.current()
            if (user![PF_USER_WEBSITE] != nil) {
                cell.websiteTextField.text = user![PF_USER_WEBSITE] as! String
            }
            return cell
        }
        if (indexPath as NSIndexPath).row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! EditProfileBioCustomTableViewCell
            cell.textView.delegate = self
            infoPlaceHolder = UILabel()
            infoPlaceHolder.font = UIFont.systemFont(ofSize: cell.textView.font!.pointSize)
            infoPlaceHolder.sizeToFit()
            cell.textView.addSubview(infoPlaceHolder)
            infoPlaceHolder.frame.origin = CGPoint(x: 5, y: cell.textView.font!.pointSize / 2)
            infoPlaceHolder.textColor = UIColor(white: 0, alpha: 0.3)
            infoPlaceHolder.isHidden = !cell.textView.text.isEmpty

            cell.infoImage.image = cell.infoImage.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            cell.infoImage.tintColor = UIColor.lightGray
            let user = PFUser.current()
            if (user![PF_USER_BIO] != nil) {
                cell.textView.text = user![PF_USER_BIO] as! String
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    // MARK: - Action methods
    
    @IBAction func save(_ sender:UIBarButtonItem) {
        let indexPath = IndexPath(row: 2, section: 0)
        let Cell = tableView.cellForRow(at: indexPath) as? EditProfileThirdCustomTableViewCell // we cast here so that you can access your custom property.
        print(Cell?.websiteTextField.text)
        let indexPath2 = IndexPath(row: 3, section: 0)
        let Cell2 = tableView.cellForRow(at: indexPath2) as? EditProfileBioCustomTableViewCell // we cast here so that you can access your custom property.
        print(Cell2?.textView.text)
        
        // Profile pic
        let user = PFUser.current()
        user![PF_USER_WEBSITE] = Cell?.websiteTextField.text
        user![PF_USER_BIO] = Cell2?.textView.text
        user!.saveInBackground()
        print("it worked")
        self.dismiss(animated: true, completion: nil)
        // Dismiss the view controller
    }
}


extension EditTableViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let currentOffset = tableView.contentOffset
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
        tableView.setContentOffset(currentOffset, animated: false)
        infoPlaceHolder.isHidden = !textView.text.isEmpty
    }
}
