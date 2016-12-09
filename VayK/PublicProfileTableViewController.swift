//
//  PublicProfileTableViewController.swift
//  VayK
//
//  Created by Hayne Park on 8/21/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit

class PublicProfileTableViewController: UITableViewController {
    
    let model = generateRandomData()
    var storedOffsets = [Int: CGFloat]()
    var groupId: String!
    var groupObject: PFUser!
    var firstName = String()
    var bio = String()
    var website = String()

    override func viewWillAppear(_ animated: Bool) {
        print(groupId)
        tableView.estimatedRowHeight = 88
        tableView.rowHeight = UITableViewAutomaticDimension
        
        firstName.removeAll()
        bio.removeAll()
        website.removeAll()
        
        var query = PFQuery(className:PF_USER_CLASS_NAME)
        query.whereKey(PF_USER_OBJECTID, equalTo:groupId)
        query.findObjectsInBackground {
            (objects: [PFObject]?, error: Error?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        self.firstName =  object[PF_USER_FIRSTNAME] as! String
                        let userBirthday = object[PF_USER_BIRTHDAY] as! String
                        self.bio = object[PF_USER_BIO] as! String
                        self.website = object[PF_USER_WEBSITE] as! String
                        self.tableView.reloadData()
                    }
                }
            }
            else {
                // Log details of the failure
                print("Error")
            }
        }
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
            let query2 = PFQuery(className:PF_USER_CLASS_NAME)
            query2.getObjectInBackground(withId: groupId) {
                (gameScore: PFObject?, error: Error?) -> Void in
                if error != nil {
                    print(error)
                } else if let gameScore = gameScore {
                    let userImageFile = gameScore[PF_USER_PICTURE] as! PFFile
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
            cell.nameLabel.text = ("\(firstName)")
            cell.infoTextView.text = bio + "\n" + website


            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
    
    @IBAction func moreButton(_ sender: AnyObject) {
        // Create an option menu as an action sheet
        let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
        // Add actions to the menu
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        optionMenu.addAction(cancelAction)
        let callActionHandler = { (action:UIAlertAction!) -> Void in
            let alertMessage = UIAlertController(title: "Are you sure?", message: nil,
                preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "No", style: .default, handler:
                nil))
            alertMessage.addAction(UIAlertAction(title: "Yes", style: .default, handler:
                nil))
            self.present(alertMessage, animated: true, completion: nil)}
        let callAction = UIAlertAction(title: "Report", style: UIAlertActionStyle.default, handler: callActionHandler)
        optionMenu.addAction(callAction)
        let isVisitedAction = UIAlertAction(title: "Send Message", style: .default,
            handler: { action in self.didSelectSingleUser(self.groupObject) }
            /*{
            (action:UIAlertAction!) -> Void in
            if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: nil)
            }
            } */
        )
        optionMenu.addAction(isVisitedAction)
        // Display the menu
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendMessage" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            chatVC.groupId = groupId
            print(sender)
        }
    }
    
    func openChat(_ groupId: String) {
        self.performSegue(withIdentifier: "sendMessage", sender: groupId)
    }
    
    func didSelectSingleUser(_ user2: PFUser) {
        let user1 = PFUser.current()
        let groupId = Messages.startPrivateChat(user1!, user2: user2)
        self.openChat(groupId)
    }

}

