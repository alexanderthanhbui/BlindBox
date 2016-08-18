//
//  AddRestaurantController.swift
//  VayK
//
//  Created by Hayne Park on 4/21/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit

class RestaurantDetailTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet var typeTextField:UITextField!
    @IBOutlet var locationTextField:UITextField!

    
    var restaurant:Restaurant!
    var nameData: String!
    var typeData: String!
    var locationData: String!
    var image: PFFile!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.nameTextField.text = nameData
        self.typeTextField.text = typeData
        self.locationTextField.text = locationData
        self.image.getDataInBackgroundWithBlock { (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData
                {
                    let image = UIImage(data: imageData)
                    var newImgThumb : UIImageView
                    newImgThumb = UIImageView(frame:CGRectMake(0, 0, 100, 70))
                    newImgThumb.contentMode = .ScaleAspectFit
                    self.imageView.image = image
                }
            }
            
        }
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath
        indexPath: NSIndexPath) {
            if indexPath.row == 0 {
                // Create an option menu as an action sheet
                let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .ActionSheet)
                // Add actions to the menu
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                optionMenu.addAction(cancelAction)
                let callActionHandler = { (action:UIAlertAction!) -> Void in
                    let alertMessage = UIAlertController(title: "Service Unavailable", message:
                        "Sorry, the Take Photo feature is not available yet. Please retry later.",
                        preferredStyle: .Alert)
                    alertMessage.addAction(UIAlertAction(title: "OK", style: .Default, handler:
                        nil))
                    self.presentViewController(alertMessage, animated: true, completion: nil)}
                let callAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.Default, handler: callActionHandler)
                optionMenu.addAction(callAction)
                let isVisitedAction = UIAlertAction(title: "Choose from Library", style: .Default,
                    handler: {
                        (action:UIAlertAction!) -> Void in
                        if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                            let imagePicker = UIImagePickerController()
                            imagePicker.allowsEditing = false
                            imagePicker.sourceType = .PhotoLibrary
                            imagePicker.delegate = self
                            self.presentViewController(imagePicker, animated: true, completion: nil)
                        }
                        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                })
                optionMenu.addAction(isVisitedAction)
                // Display the menu
                self.presentViewController(optionMenu, animated: true, completion: nil)
            }
    }
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [String : AnyObject]) {
            imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            imageView.clipsToBounds = true
            let leadingConstraint = NSLayoutConstraint(item: imageView, attribute:
                NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem:
                imageView.superview, attribute: NSLayoutAttribute.Leading, multiplier: 1,
                constant: 0)
            leadingConstraint.active = true
            let trailingConstraint = NSLayoutConstraint(item: imageView, attribute:
                NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem:
                imageView.superview, attribute: NSLayoutAttribute.Trailing, multiplier: 1,
                constant: 0)
            trailingConstraint.active = true
            let topConstraint = NSLayoutConstraint(item: imageView, attribute:
                NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem:
                imageView.superview, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
            topConstraint.active = true
            let bottomConstraint = NSLayoutConstraint(item: imageView, attribute:
                NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem:
                imageView.superview, attribute: NSLayoutAttribute.Bottom, multiplier: 1,
                constant: 0)
            bottomConstraint.active = true
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Action methods
    
    @IBAction func save(sender:UIBarButtonItem) {
        let restaurantImage = imageView.image
        let name = nameTextField.text
        let type = typeTextField.text
        let location = locationTextField.text
        
        // Validate input fields
        if name == "" || type == "" || location == "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return
        }
        
        // Print input data to console
        print("Name: \(name)")
        print("Type: \(type)")
        print("Location: \(location)")
        
        let query2 = PFQuery(className:"Restaurants")
        query2.whereKey("Name", equalTo: nameData)
        query2.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        var idData = object.objectId
                        print(idData)
                        query2.getObjectInBackgroundWithId(idData!) {
                            (gameScore: PFObject?, var error: NSError?) -> Void in
                            if error != nil {
                                print(error)
                            } else if let gameScore = gameScore {
                                var userObjectID = PFUser.currentUser()!.objectId
                                let imageData = UIImageJPEGRepresentation(restaurantImage!, 0.6)
                                let image = PFFile(data: imageData!)
                                gameScore["Name"] = name
                                gameScore["Type"] = type
                                gameScore["Location"] = location
                                gameScore["Pointer"] = userObjectID
                                gameScore["Image"] = image
                                do {
                                    try gameScore.save()
                                }
                                catch let er as NSError {
                                    error = er
                                }
                                print("it worked")
                                // Dismiss the view controller
                                self.dismissViewControllerAnimated(true, completion: nil)
                            }
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
}