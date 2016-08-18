//
//  AddRestaurantController.swift
//  VayK
//
//  Created by Hayne Park on 4/21/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI

class AddTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBAction func unwindToCreate(segue: UIStoryboardSegue) {}
    @IBAction func unwindToCreateFromCategory(segue: UIStoryboardSegue) {}
    @IBAction func backButton(sender: AnyObject) {}
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    var isVisited = true
    var restaurant:Restaurant!
    var locationManager = CLLocationManager()
    let user = PFUser.currentUser()
    
    func reverseGeocoding(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            else if placemarks?.count > 0 {
                let pm = placemarks![0]
                let address = ABCreateStringWithAddressDictionary(pm.addressDictionary!, false)
                print("\n\(address)")
                // City
                let city = pm.addressDictionary!["City"] as! NSString
                    print(city)
                
                // State
                let state = pm.addressDictionary!["State"] as!NSString
                    print(state)
                self.locationLabel.text = "\(city), \(state)"

                
                if pm.areasOfInterest?.count > 0 {
                    let areaOfInterest = pm.areasOfInterest?[0]
                    print(areaOfInterest!)
                } else {
                    print("No area of interest found.")
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        //load view with persistent category value
        let defaults = NSUserDefaults.standardUserDefaults()
        let Category = defaults.integerForKey("createCategory")
        if Category == 0 {
            categoryLabel.text = "Arts"
        }
        else if Category == 1 {
            categoryLabel.text = "Classes"
        }
        else if Category == 2 {
            categoryLabel.text = "Education"
        }
        else if Category == 3 {
            categoryLabel.text = "Food & Drinks"
        }
        else if Category == 4 {
            categoryLabel.text = "Misc."
        }
        else if Category == 5 {
            categoryLabel.text = "Music"
        }
        else if Category == 6 {
            categoryLabel.text = "Networking"
        }
        else if Category == 7 {
            categoryLabel.text = "Social"
        }
        else if Category == 8 {
            categoryLabel.text = "Sports"
        }
        else if Category == 9 {
            categoryLabel.text = "Category"
        }
        
        //load view with persistent gender value
        let Gender = defaults.integerForKey("createGender")
        if Gender == 0 {
            genderLabel.text = "Only Men"
        }
        else if Gender == 1 {
            genderLabel.text = "Only Women"
        }
        else if Gender == 2 {
            genderLabel.text = "Men and Women"
        }
        else if Gender == 3 {
            genderLabel.text = "Gender"
        }
        
        //load view with persistent timeline value
        let timelineSliderValue = NSUserDefaults.standardUserDefaults().floatForKey("create_blindbox_timeline_slider_value")
        let timelineCurrentInt = Int(timelineSliderValue)
        let timelineCurrentString = String(timelineCurrentInt)
        if timelineCurrentInt == 0 {
            timelineLabel.text = "Now"
        }
        else if timelineCurrentInt == 1 {
            timelineLabel.text = "\(timelineCurrentString) day"
        }
        else {
            timelineLabel.text = "\(timelineCurrentString) days"
        }
        timelineSlider.value = timelineSliderValue
        
        //load view with persistent blindbox size value
        let blindBoxSliderValue = NSUserDefaults.standardUserDefaults().floatForKey("create_blindbox_size_slider_value")
        let blindBoxSizeCurrentInt = Int(blindBoxSliderValue)
        let blindBoxSizeCurrentString = String(blindBoxSizeCurrentInt)
        if blindBoxSizeCurrentInt == 10 {
            blindBoxSizeLabel.text = "\(blindBoxSizeCurrentString)+"
        }
        else {
            blindBoxSizeLabel.text = "\(blindBoxSizeCurrentString)"
        }
        blindBoxSizeSlider.value = blindBoxSliderValue
        
        //load view with persistent minimum blindbox age value
        let minBlindBoxAgeSliderValue = NSUserDefaults.standardUserDefaults().floatForKey("create_blindbox_min_age_slider_value")
        let minBlindBoxAgeCurrentInt = Int(minBlindBoxAgeSliderValue)
        let minBlindBoxAgeCurrentString = String(minBlindBoxAgeCurrentInt)
        if minBlindBoxAgeCurrentInt == 65 {
            minBlindBoxAgeLabel.text = "\(minBlindBoxAgeCurrentString)+"
        }
        else {
            minBlindBoxAgeLabel.text = "\(minBlindBoxAgeCurrentString)"
        }
        minBlindBoxAgeSlider.value = minBlindBoxAgeSliderValue
        
        //load view with persistent maximum blindbox age value
        let maxBlindBoxAgeSliderValue = NSUserDefaults.standardUserDefaults().floatForKey("create_blindbox_max_age_slider_value")
        let maxBlindBoxAgeCurrentInt = Int(maxBlindBoxAgeSliderValue)
        let maxBlindBoxAgeCurrentString = String(maxBlindBoxAgeCurrentInt)
        if maxBlindBoxAgeCurrentInt == 65 {
            maxBlindBoxAgeLabel.text = "\(maxBlindBoxAgeCurrentString)+"
        }
        else {
            maxBlindBoxAgeLabel.text = "\(maxBlindBoxAgeCurrentString)"
        }
        maxBlindBoxAgeSlider.value = maxBlindBoxAgeSliderValue

        
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        print("Get GPS")
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint, error ) -> Void in
            if error == nil {
                self.user!["Location"] = geoPoint
                self.user!.saveInBackground()
                print(geoPoint)
                let latitude  = geoPoint?.latitude
                let longitude = geoPoint?.longitude
                self.reverseGeocoding(latitude!, longitude: longitude!)
            } else {
                print(error) //No error either
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath
        indexPath: NSIndexPath) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)

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
                let gender = genderLabel.text
                let category = categoryLabel.text

        
                // Validate input fields
                if name == "" || category == "Category" || gender == "Gender" {
                let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                
                return
                }
                
                // Print input data to console
                print("Name: \(name)")
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint, error ) -> Void in
            if error == nil {


        let userObjectID = PFUser.currentUser()!.objectId
        let pointer = PFObject(withoutDataWithClassName:"Users", objectId: userObjectID)
        let imageData = UIImageJPEGRepresentation(restaurantImage!, 0.6)
        let image = PFFile(data: imageData!)
     
        let object = PFObject(className: PF_GROUPS_CLASS_NAME)
        object[PF_GROUPS_NAME] = name
        object[PF_GROUPS_NAME_LOWER] = name?.lowercaseString
        object[PF_GROUPS_GENDER] = gender
        object[PF_GROUPS_LOCATION] = geoPoint
        object[PF_GROUPS_TIMELINE] = Int(self.timelineSlider.value)
        object[PF_GROUPS_SIZE] = self.blindBoxSizeSlider.value
        object[PF_GROUPS_AGE_MINIMUM] = Int(self.minBlindBoxAgeSlider.value)
        object[PF_GROUPS_AGE_MAXIMUM] = Int(self.maxBlindBoxAgeSlider.value)
        object[PF_GROUPS_IMAGE] = image
        object[PF_GROUPS_POINTER] = self.user!.objectId
        object.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                print("yay")
            } else {
                // There was a problem, check error.description
                print(error)
            }
        }
                // Dismiss the view controller
                self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                print(error) //No error either
            }
        }
    }
    
    // Minimum Timeline Code
    @IBAction func timelineValueChangedEnd(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setFloat(timelineSlider.value, forKey: "create_blindbox_timeline_slider_value")
    }
    @IBOutlet weak var timelineSlider: UISlider!
    @IBOutlet weak var timelineLabel: UILabel!
    @IBAction func timelineValueChanged(sender: AnyObject) {
        let currentValue = Int(timelineSlider.value)
        if currentValue == 0 {
            timelineLabel.text = "Now"
        }
        else if currentValue == 1 {
            timelineLabel.text = "\(currentValue) Day"
        }
        else {
            timelineLabel.text = "\(currentValue) Days"
        }
    }
    
    
    // BlindBox Size Code
    @IBAction func blindBoxSizeValueChangeEnd(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setFloat(blindBoxSizeSlider.value, forKey: "create_blindbox_size_slider_value")
    }
    @IBOutlet weak var blindBoxSizeSlider: UISlider!
    @IBOutlet weak var blindBoxSizeLabel: UILabel!
    @IBAction func blindBoxSizeValueChanged(sender: AnyObject) {
        let currentValue = Int(blindBoxSizeSlider.value)
        
        if currentValue == 10 {
            blindBoxSizeLabel.text = "\(currentValue)+"
        }
        else {
            blindBoxSizeLabel.text = "\(currentValue)"
        }
    }
    
    // Minimum Age Code
    @IBAction func minBlindBoxAgeValueChangeEnd(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setFloat(minBlindBoxAgeSlider.value, forKey: "create_blindbox_min_age_slider_value")
    }
    @IBOutlet weak var minBlindBoxAgeSlider: UISlider!
    @IBOutlet weak var minBlindBoxAgeLabel: UILabel!
    @IBAction func minBlindBoxAgeValueChanged(sender: AnyObject) {
        let maxInt = Int(maxBlindBoxAgeSlider.value)
        let maxFloat = Float(maxInt)
        let maxValue: Float = maxFloat
        if (sender as! UISlider).value > maxValue {
            (sender as! UISlider).value = maxValue
        }
        let currentValue = Int(minBlindBoxAgeSlider.value)
        
        if currentValue == 65 {
            minBlindBoxAgeLabel.text = "\(currentValue)+"
        }
        else {
            minBlindBoxAgeLabel.text = "\(currentValue)"
        }
    }
    
    // Maximum Age Code
    @IBAction func maxBlindBoxAgeValueChangedEnd(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().setFloat(maxBlindBoxAgeSlider.value, forKey: "create_blindbox_max_age_slider_value")
    }
    @IBOutlet weak var maxBlindBoxAgeSlider: UISlider!
    @IBOutlet weak var maxBlindBoxAgeLabel: UILabel!
    @IBAction func maxBlindBoxAgeValueChanged(sender: AnyObject) {
        let maxInt = Int(minBlindBoxAgeSlider.value)
        let maxFloat = Float(maxInt)
        let maxValue: Float = maxFloat
        if (sender as! UISlider).value < maxValue {
            (sender as! UISlider).value = maxValue
        }
        let currentValue = Int(maxBlindBoxAgeSlider.value)
        
        if currentValue == 65 {
            maxBlindBoxAgeLabel.text = "\(currentValue)+"
        }
        else {
            maxBlindBoxAgeLabel.text = "\(currentValue)"
        }
    }
}
