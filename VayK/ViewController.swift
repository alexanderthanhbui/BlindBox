//
//  ViewController.swift
//  VayK
//
//  Created by Matthew Goldspink on 8/26/15.
//  Copyright (c) 2015 mgoldspink. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import FBSDKLoginKit
import FBSDKCoreKit
import ParseFacebookUtilsV4
import CoreLocation
import AddressBookUI

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
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
                if let city = pm.addressDictionary!["City"] as? NSString {
                    print(city)
                }
                // State
                if let state = pm.addressDictionary!["State"] as? NSString {
                    print(state)
                }
                if pm.areasOfInterest?.count > 0 {
                    let areaOfInterest = pm.areasOfInterest?[0]
                    print(areaOfInterest!)
                } else {
                    print("No area of interest found.")
                }
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if (PFUser.currentUser() == nil) {
            let loginViewController = LoginViewController()
            loginViewController.delegate = self
            loginViewController.fields = [.Facebook]
            loginViewController.emailAsUsername = true
            loginViewController.signUpController?.delegate = self
            self.presentViewController(loginViewController, animated: false, completion: nil)
            // If we have an access token, then let's display some info
            
            if (FBSDKAccessToken.currentAccessToken() != nil)
            {
                // Display current FB premissions
                print (FBSDKAccessToken.currentAccessToken().permissions)
                
                // Since we already logged in we can display the user datea and taggable friend data.
                self.showUserData()
                self.showFriendData()
            }
        } else {

        
            self.performSegueWithIdentifier("lol", sender: self)
            if (FBSDKAccessToken.currentAccessToken() != nil)
            {
                // Display current FB premissions
                print (FBSDKAccessToken.currentAccessToken().permissions)
                
                // Since we already logged in we can display the user datea and taggable friend data.
                self.showUserData()
                self.showFriendData()
            }

        }

    }
    func showUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, first_name, last_name, email, birthday, gender, picture.height(10800).width(10800)"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {


                let facebookID : NSString = result.valueForKey("id") as! NSString

                
                // Profile pic
                let user = PFUser.currentUser()
                        var imgURLString = "http://graph.facebook.com/\(facebookID)/picture?width=1080" //type=normal
                        var imgURL = NSURL(string: imgURLString)
                        var imageData = NSData(contentsOfURL: imgURL!)
                        var image = UIImage(data: imageData!)
                                        let imageData2 = UIImagePNGRepresentation(image!)
                                        let imageFile = PFFile(name:"image.png", data:imageData2!)
                                        user!["UserImage"] = imageFile
                                        user!.saveInBackground()
                                        print("it worked")
                                        // Dismiss the view controller
                
                                
            let userFirstName : NSString = result.valueForKey("first_name") as! NSString
            let userLastName : NSString = result.valueForKey("last_name") as! NSString
                // Request birthdate
                let userBirthday : NSString = result.valueForKey("birthday") as! NSString
                
                // Request gender
                let userGender : NSString = result.valueForKey("gender") as! NSString
                
                // Request email
                let userEmail : NSString = result.valueForKey("email") as! NSString
                
                // Request Facebook ID
                let fbid : NSString = result.valueForKey("id") as! NSString

                
                    // Convert String to NSDate
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "MM-dd-yyy"
                    let date = dateFormatter.dateFromString(userBirthday as String)
                    let birthday: NSDate = date!
                    var now: NSDate = NSDate()
                    var ageComponents: NSDateComponents = NSCalendar.currentCalendar().components(.Year, fromDate: birthday, toDate: now, options: [])
                    var age: Int = ageComponents.year
                
                self.locationManager.delegate = self
                self.locationManager.requestWhenInUseAuthorization()
                print("Get GPS")
                PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint, error ) -> Void in
                    if error == nil {
                                user!["FirstName"] = userFirstName
                                user!["FirstnameLower"] = userFirstName.lowercaseString
                                user!["LastName"] = userLastName
                                user!["Email"] = userEmail
                                user!["FacebookID"] = fbid
                                user!["Location"] = geoPoint
                                user!["Birthday"] = userBirthday
                                user!["Gender"] = userGender
                                user!.saveInBackground()
                                print("pooop")
                                print(geoPoint)
                        let lol  = geoPoint?.latitude
                        let lol2 = geoPoint?.longitude
                        self.reverseGeocoding(lol!, longitude: lol2!)


                        
                        
                    } else {
                        print(error) //No error either
                    }
                }
            }
        })
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .NotDetermined:
locationManager.requestWhenInUseAuthorization()
print("lol")
            break
        case .AuthorizedWhenInUse:
locationManager.requestWhenInUseAuthorization()
print("lol")
            break
        case .AuthorizedAlways:
locationManager.requestWhenInUseAuthorization()
print("lol")
            break
        case .Restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .Denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    func showFriendData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/taggable_friends?limit=999", parameters: ["fields" : "name"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                if let friends : NSArray = result.valueForKey("data") as? NSArray{
                    var i = 1
                    for obj in friends {
                        if let name = obj["name"] as? String {
                            print("\(i) " + name)
                            i++
                        }
                    }
                }
            }
        })
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        self.dismissViewControllerAnimated(true, completion: nil)
        //presentLoggedInAlert()
        self.performSegueWithIdentifier("lol", sender: self)

    }
    
    func presentLoggedInAlert() {
        let alertController = UIAlertController(title: "You're logged in", message: "Welcome to Blind Box", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.performSegueWithIdentifier("lol", sender: self)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

