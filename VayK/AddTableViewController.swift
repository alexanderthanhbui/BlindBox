//
//  AddTableViewController.swift
//  VayK
//
//  Created by Hayne Park on 11/28/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class AddTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate, UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBAction func unwindToCreate(_ segue: UIStoryboardSegue) {}
    @IBAction func unwindToCreateFromCategory(_ segue: UIStoryboardSegue) {}
    @IBAction func backButton(_ sender: AnyObject) {}
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var nameTextField:UITextField!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var minuteLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!


    @IBAction func datePickerAction(_ sender: AnyObject) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, ddMMM-yyyy hh:mm"
        //var strDate = dateFormatter.stringFromDate(pickerView.)
        //self.timelineLabel.text = strDate
    }
    
    var isVisited = true
    var restaurant:Restaurant!
    var locationManager = CLLocationManager()
    let user = PFUser.current()
    var city = ""
    var wheelContents:[[String]] = []
    var wheelForYear:[[String]] = []


    var dayOne: String {
        let dayOneComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 0, to:Date(), options: [])!
        let dayOneFormatter = DateFormatter()
        dayOneFormatter.dateFormat = "eee d MMM"
        return dayOneFormatter.string(from: dayOneComponents)
        //dateString now contains the string ex."Fri".
    }
    
    var dayTwo: String {
        let dayTwoComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to:Date(), options: [])!
        let dayTwoFormatter = DateFormatter()
        dayTwoFormatter.dateFormat = "eee d MMM"
        return dayTwoFormatter.string(from: dayTwoComponents)
        //dateString now contains the string ex."Fri".
    }
 
    var dayThree: String {
        let dayThreeComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 2, to:Date(), options: [])!
        let dayThreeFormatter = DateFormatter()
        dayThreeFormatter.dateFormat = "eee d MMM"
        return dayThreeFormatter.string(from: dayThreeComponents)
        //dateString now contains the string ex."Fri".
    }
    
    var dayFour: String {
        let dayFourComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 3, to:Date(), options: [])!
        let dayFourFormatter = DateFormatter()
        dayFourFormatter.dateFormat = "eee d MMM"
        return dayFourFormatter.string(from: dayFourComponents)
        //dateString now contains the string ex."Fri".
    }
    
    var dayFive: String {
        let dayFiveComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 4, to:Date(), options: [])!
        let dayFiveFormatter = DateFormatter()
        dayFiveFormatter.dateFormat = "eee d MMM"
        return dayFiveFormatter.string(from: dayFiveComponents)
        //dateString now contains the string ex."Fri".
    }
    
    var daySix: String {
        let daySixComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 5, to:Date(), options: [])!
        let daySixFormatter = DateFormatter()
        daySixFormatter.dateFormat = "eee d MMM"
        return daySixFormatter.string(from: daySixComponents)
        //dateString now contains the string ex."Fri".
    }
    
    var daySeven: String {
        let daySevenComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 6, to:Date(), options: [])!
        let daySevenFormatter = DateFormatter()
        daySevenFormatter.dateFormat = "eee d MMM"
        return daySevenFormatter.string(from: daySevenComponents)
        //dateString now contains the string ex."Fri".
    }
    
    var dateData: [String] {
        return ["Today",dayTwo,dayThree,dayFour,dayFive,daySix,daySeven]
    }
    let hourData = ["12","1","2","3","4","5","6","7","8","9","10","11"]
    let minuteData = ["00","05","10","15","20","25","30","35","40","45","50","55"]
    let timeData = ["AM","PM"]
    
    var yearData: [String] {
        return [dayOneForYear,dayTwoForYear,dayThreeForYear,dayFourForYear,dayFiveForYear,daySixForYear,daySevenForYear]
    }

    var dayOneForYear: String {
        let dayOneComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 0, to:Date(), options: [])!
        let dayOneFormatter = DateFormatter()
        dayOneFormatter.dateFormat = "yyyy eee d MMM"
        return dayOneFormatter.string(from: dayOneComponents)
        //dateString now contains the string ex."Fri".
    }
    
    var dayTwoForYear: String {
        let dayTwoComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 1, to:Date(), options: [])!
        let dayTwoFormatter = DateFormatter()
        dayTwoFormatter.dateFormat = "yyyy eee d MMM"
        return dayTwoFormatter.string(from: dayTwoComponents)
        //dateString now contains the string ex."Fri".
    }
    
    var dayThreeForYear: String {
        let dayThreeComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 2, to:Date(), options: [])!
        let dayThreeFormatter = DateFormatter()
        dayThreeFormatter.dateFormat = "yyyy eee d MMM"
        return dayThreeFormatter.string(from: dayThreeComponents)
        //dateString now contains the string ex."Fri".
    }
    
    var dayFourForYear: String {
        let dayFourComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 3, to:Date(), options: [])!
        let dayFourFormatter = DateFormatter()
        dayFourFormatter.dateFormat = "yyyy eee d MMM"
        return dayFourFormatter.string(from: dayFourComponents)
        //dateString now contains the string ex."Fri".
    }
    
    var dayFiveForYear: String {
        let dayFiveComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 4, to:Date(), options: [])!
        let dayFiveFormatter = DateFormatter()
        dayFiveFormatter.dateFormat = "yyyy eee d MMM"
        return dayFiveFormatter.string(from: dayFiveComponents)
        //dateString now contains the string ex."Fri".
    }
    
    var daySixForYear: String {
        let daySixComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 5, to:Date(), options: [])!
        let daySixFormatter = DateFormatter()
        daySixFormatter.dateFormat = "yyyy eee d MMM"
        return daySixFormatter.string(from: daySixComponents)
        //dateString now contains the string ex."Fri".
    }
    
    var daySevenForYear: String {
        let daySevenComponents = (Calendar.current as NSCalendar).date(byAdding: .day, value: 6, to:Date(), options: [])!
        let daySevenFormatter = DateFormatter()
        daySevenFormatter.dateFormat = "yyyy eee d MMM"
        return daySevenFormatter.string(from: daySevenComponents)
        //dateString now contains the string ex."Fri".
    }
    
    func reverseGeocoding(_ latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
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
                self.city = city as String

                
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
        pickerView.dataSource = self
        pickerView.delegate = self
        //UIPicker
    
        wheelContents = [dateData,hourData,minuteData,timeData]
        wheelForYear = [yearData]

    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, rowWidthForComponent component: Int) -> CGFloat {
        
        return 40
    }
    
    func numberOfComponents(in bigPicker: UIPickerView) -> Int{
        return wheelContents.count
        
    }
    
    // returns the # of rows in each component..
    func pickerView(_ bigPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        return wheelContents[component].count
    }
    
    func pickerView(_ bigPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        return wheelContents[component][row]
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()

        
        switch component {
        case 0:
            let pickerLabel = UILabel()
            let titleData = wheelContents[0][row]
            let myTitle = NSAttributedString(string: titleData)
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = .right
            return pickerLabel
        case 1:
            let pickerLabel = UILabel()
            let titleData = wheelContents[1][row]
            let myTitle = NSAttributedString(string: titleData)
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = .right
            return pickerLabel
        case 2:
            let pickerLabel = UILabel()
            let titleData = wheelContents[2][row]
            let myTitle = NSAttributedString(string: titleData)
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = .right
            return pickerLabel
        case 3:
            let pickerLabel = UILabel()
            let titleData = wheelContents[3][row]
            let myTitle = NSAttributedString(string: titleData)
            pickerLabel.attributedText = myTitle
            pickerLabel.textAlignment = .right
            return pickerLabel
        default:
            break
        }
        return pickerLabel
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch component {
        case 0:
            return 100
        case 1:
            return 25
        case 2:
            return 50
        case 3:
            return 50
        default:
            break
        }
        return 200
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.timelineLabel.text = ("\(wheelContents[0][row])")
            UserDefaults.standard.set(row, forKey: "create_blindbox_day_value")
        case 1:
            self.hourLabel.text = ("\(wheelContents[1][row]):")
            UserDefaults.standard.set(row, forKey: "create_blindbox_hour_value")
        case 2:
            self.minuteLabel.text = ("\(wheelContents[2][row])")
            UserDefaults.standard.set(row, forKey: "create_blindbox_minute_value")
        case 3:
            self.timeLabel.text = ("\(wheelContents[3][row])")
            UserDefaults.standard.set(row, forKey: "create_blindbox_meridiem_value")
        default:
            break
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        //load view with persistent category value
        let defaults = UserDefaults.standard
        let Category = defaults.integer(forKey: "createCategory")
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
        
        //load view with pickerView value
        let dateRow = defaults.integer(forKey: "create_blindbox_day_value")
            pickerView.selectRow(dateRow, inComponent: 0, animated: true)
        let hourRow = defaults.integer(forKey: "create_blindbox_hour_value")
            pickerView.selectRow(hourRow, inComponent: 1, animated: true)
        print(hourRow)
        print("^this is the current hour")
        let minuteRow = defaults.integer(forKey: "create_blindbox_minute_value")
        if minuteRow == 60 {
            pickerView.selectRow(0, inComponent: 2, animated: true)
            minuteLabel.text = wheelContents[2][0]
            UserDefaults.standard.set(0, forKey: "create_blindbox_minute_value")
        }
        if minuteRow == 5 {
            pickerView.selectRow(1, inComponent: 2, animated: true)
            minuteLabel.text = wheelContents[2][1]
            UserDefaults.standard.set(1, forKey: "create_blindbox_minute_value")
        }
        if minuteRow == 10 {
            pickerView.selectRow(2, inComponent: 2, animated: true)
            minuteLabel.text = wheelContents[2][2]
            UserDefaults.standard.set(2, forKey: "create_blindbox_minute_value")

        }
        if minuteRow == 15 {
            pickerView.selectRow(3, inComponent: 2, animated: true)
            minuteLabel.text = wheelContents[2][3]
            UserDefaults.standard.set(3, forKey: "create_blindbox_minute_value")
        }
        if minuteRow == 20 {
            pickerView.selectRow(4, inComponent: 2, animated: true)
            minuteLabel.text = wheelContents[2][4]
            UserDefaults.standard.set(4, forKey: "create_blindbox_minute_value")
        }
        if minuteRow == 25 {
            pickerView.selectRow(5, inComponent: 2, animated: true)
            minuteLabel.text = wheelContents[2][5]
            UserDefaults.standard.set(5, forKey: "create_blindbox_minute_value")
        }
        if minuteRow == 30 {
            pickerView.selectRow(6, inComponent: 2, animated: true)
            minuteLabel.text = wheelContents[2][6]
            UserDefaults.standard.set(6, forKey: "create_blindbox_minute_value")
        }
        if minuteRow == 35 {
            pickerView.selectRow(7, inComponent: 2, animated: true)
            minuteLabel.text = wheelContents[2][7]
            UserDefaults.standard.set(7, forKey: "create_blindbox_minute_value")
        }
        if minuteRow == 40 {
            pickerView.selectRow(8, inComponent: 2, animated: true)
            minuteLabel.text = wheelContents[2][8]
            UserDefaults.standard.set(8, forKey: "create_blindbox_minute_value")
        }
        if minuteRow == 45 {
            pickerView.selectRow(9, inComponent: 2, animated: true)
            minuteLabel.text = wheelContents[2][9]
            UserDefaults.standard.set(9, forKey: "create_blindbox_minute_value")
        }
        if minuteRow == 50 {
            pickerView.selectRow(10, inComponent: 2, animated: true)
            minuteLabel.text = wheelContents[2][10]
            UserDefaults.standard.set(10, forKey: "create_blindbox_minute_value")
        }
        if minuteRow == 55 {
            pickerView.selectRow(11, inComponent: 2, animated: true)
            minuteLabel.text = wheelContents[2][11]
            UserDefaults.standard.set(11, forKey: "create_blindbox_minute_value")
        }
        
        let meridiemRow = defaults.integer(forKey: "create_blindbox_meridiem_value")
            pickerView.selectRow(meridiemRow, inComponent: 3, animated: true)
        
        //load view label with pickerView
        self.timelineLabel.text = wheelContents[0][dateRow]
        self.hourLabel.text = ("\(wheelContents[1][hourRow]):")
        self.timeLabel.text = wheelContents[3][meridiemRow]
        
        print("\(dateRow)T\(hourRow):\(minuteRow)")


        //load view with persistent gender value
        let Gender = defaults.integer(forKey: "createGender")
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
        
        let blindBoxSliderValue = UserDefaults.standard.float(forKey: "create_blindbox_size_slider_value")
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
        let minBlindBoxAgeSliderValue = UserDefaults.standard.float(forKey: "create_blindbox_min_age_slider_value")
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
        let maxBlindBoxAgeSliderValue = UserDefaults.standard.float(forKey: "create_blindbox_max_age_slider_value")
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
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error ) -> Void in
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

    override func tableView(_ tableView: UITableView, didSelectRowAt
        indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)

        if (indexPath as NSIndexPath).row == 0 {
            // Create an option menu as an action sheet
            let optionMenu = UIAlertController(title: nil, message: "What do you want to do?", preferredStyle: .actionSheet)
            // Add actions to the menu
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            optionMenu.addAction(cancelAction)
            let callActionHandler = { (action:UIAlertAction!) -> Void in
                let alertMessage = UIAlertController(title: "Service Unavailable", message:
                "Sorry, the Take Photo feature is not available yet. Please retry later.",
                preferredStyle: .alert)
                alertMessage.addAction(UIAlertAction(title: "OK", style: .default, handler:
                nil))
                self.present(alertMessage, animated: true, completion: nil)}
            let callAction = UIAlertAction(title: "Take Photo", style: UIAlertActionStyle.default, handler: callActionHandler)
            optionMenu.addAction(callAction)
            let isVisitedAction = UIAlertAction(title: "Choose from Library", style: .default,
                    handler: {
                    (action:UIAlertAction!) -> Void in
                    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    self.present(imagePicker, animated: true, completion: nil)
                    }
                    tableView.deselectRow(at: indexPath, animated: true)
                    })
            optionMenu.addAction(isVisitedAction)
            // Display the menu
            self.present(optionMenu, animated: true, completion: nil)
            }
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [String : Any]) {
            imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
            imageView.contentMode = UIViewContentMode.scaleAspectFill
            imageView.clipsToBounds = true
            let leadingConstraint = NSLayoutConstraint(item: imageView, attribute:
            NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem:
            imageView.superview, attribute: NSLayoutAttribute.leading, multiplier: 1,
            constant: 0)
            leadingConstraint.isActive = true
            let trailingConstraint = NSLayoutConstraint(item: imageView, attribute:
            NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem:
            imageView.superview, attribute: NSLayoutAttribute.trailing, multiplier: 1,
            constant: 0)
            trailingConstraint.isActive = true
            let topConstraint = NSLayoutConstraint(item: imageView, attribute:
            NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem:
            imageView.superview, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            topConstraint.isActive = true
            let bottomConstraint = NSLayoutConstraint(item: imageView, attribute:
            NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem:
            imageView.superview, attribute: NSLayoutAttribute.bottom, multiplier: 1,
            constant: 0)
            bottomConstraint.isActive = true
            dismiss(animated: true, completion: nil)
    }

    // MARK: - Action methods
    
    @IBAction func save(_ sender:UIBarButtonItem) {
                let restaurantImage = imageView.image
                let name = nameTextField.text
                let gender = genderLabel.text
                let category = categoryLabel.text
        
        let defaults = UserDefaults.standard
        let dateRow = defaults.integer(forKey: "create_blindbox_day_value")
        pickerView.selectRow(dateRow, inComponent: 0, animated: true)
        let hourRow = defaults.integer(forKey: "create_blindbox_hour_value")
        pickerView.selectRow(hourRow, inComponent: 1, animated: true)
        let minuteRow = defaults.integer(forKey: "create_blindbox_minute_value")
        pickerView.selectRow(minuteRow, inComponent: 2, animated: true)
        let meridiemRow = defaults.integer(forKey: "create_blindbox_meridiem_value")
        pickerView.selectRow(meridiemRow, inComponent: 3, animated: true)
        
                // Validate input fields
        if name == "" || category == "Category" || gender == "Gender" {
        let alertController = UIAlertController(title: "Oops", message: "We can't proceed because one of the fields is blank. Please note that all fields are required.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
                
                return
                }
        // convert start time string to date format
        var dateString = "\(wheelForYear[0][dateRow]) \(wheelContents[1][hourRow]):\(wheelContents[2][minuteRow]) \(wheelContents[3][meridiemRow])"
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy eee d MMM h:mm a"
        
        var date = dateFormatter.date(from: dateString)
        print(date)
        
        
                // Print input data to console
                print("Name: \(name)")
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error ) -> Void in
            if error == nil {


        let userObjectID = PFUser.current()!.objectId
        let userIDArray = [PFUser.current()!.objectId!]
        let pointer = PFObject(withoutDataWithClassName:"Users", objectId: userObjectID)
        let imageData = UIImageJPEGRepresentation(restaurantImage!, 0.6)
        let image = PFFile(data: imageData!)
     
        let object = PFObject(className: PF_GROUPS_CLASS_NAME)
        object[PF_GROUPS_NAME] = name
        object[PF_GROUPS_NAME_LOWER] = name?.lowercased()
        object[PF_GROUPS_GENDER] = gender
        object[PF_GROUPS_LOCATION] = geoPoint
        object[PF_GROUPS_CITY] = self.city
        object[PF_GROUPS_TIMELINE] = date
        object[PF_GROUPS_SIZE] = self.blindBoxSizeSlider.value
        object[PF_GROUPS_AGE_MINIMUM] = Int(self.minBlindBoxAgeSlider.value)
        object[PF_GROUPS_AGE_MAXIMUM] = Int(self.maxBlindBoxAgeSlider.value)
        object[PF_GROUPS_IMAGE] = image
        object[PF_GROUPS_FULL] = false
        object[PF_GROUPS_POINTER] = userIDArray
        object.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print("yay")
            } else {
                // There was a problem, check error.description
                print("There was a problem, check error.description")
            }
                }
                // Dismiss the view controller
                self.dismiss(animated: true, completion: nil)
            } else {
                print(error) //No error either
            }
        }
    }

    @IBOutlet weak var timelineLabel: UILabel!

    // BlindBox Size Code
    @IBAction func blindBoxSizeValueChangeEnd(_ sender: AnyObject) {
        UserDefaults.standard.set(blindBoxSizeSlider.value, forKey: "create_blindbox_size_slider_value")
    }
    @IBOutlet weak var blindBoxSizeSlider: UISlider!
    @IBOutlet weak var blindBoxSizeLabel: UILabel!
    @IBAction func blindBoxSizeValueChanged(_ sender: AnyObject) {
        let currentValue = Int(blindBoxSizeSlider.value)
        
        if currentValue == 10 {
            blindBoxSizeLabel.text = "\(currentValue)+"
        }
        else {
            blindBoxSizeLabel.text = "\(currentValue)"
        }
    }
    
    // Minimum Age Code
    @IBAction func minBlindBoxAgeValueChangeEnd(_ sender: AnyObject) {
        UserDefaults.standard.set(minBlindBoxAgeSlider.value, forKey: "create_blindbox_min_age_slider_value")
    }
    @IBOutlet weak var minBlindBoxAgeSlider: UISlider!
    @IBOutlet weak var minBlindBoxAgeLabel: UILabel!
    @IBAction func minBlindBoxAgeValueChanged(_ sender: AnyObject) {
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
    @IBAction func maxBlindBoxAgeValueChangedEnd(_ sender: AnyObject) {
        UserDefaults.standard.set(maxBlindBoxAgeSlider.value, forKey: "create_blindbox_max_age_slider_value")
    }
    @IBOutlet weak var maxBlindBoxAgeSlider: UISlider!
    @IBOutlet weak var maxBlindBoxAgeLabel: UILabel!
    @IBAction func maxBlindBoxAgeValueChanged(_ sender: AnyObject) {
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
