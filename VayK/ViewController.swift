//
//  ViewController.swift
//  VayK
//
//  Created by Hayne Park on 11/27/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import ParseFacebookUtilsV4
import Parse
import ParseUI
import Bolts
import CoreLocation

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
   
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Request location permission when in use
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //
        if (PFUser.current() == nil) {
            let loginViewController = LoginViewController()
            loginViewController.delegate = self
            loginViewController.fields = [.facebook]
            loginViewController.emailAsUsername = true
            loginViewController.signUpController?.delegate = self
            self.present(loginViewController, animated: false, completion: nil)
            
            // If we have an access token, then let's display some info
            if (FBSDKAccessToken.current() != nil)
            {
                // Display current FB premissions
                print (FBSDKAccessToken.current().permissions)
                
                // Since we already logged in we can display the user datea and taggable friend data.
                FacebookAPI.sharedInstance().showUserData(completionHandler: { (data, error) in
                    if let data = data {
                        FacebookAPI.sharedInstance().getFBPhoto(facebookID: data["id"] as! String, completionHandler: { (imageFile, error) in
                            if let imageFile = imageFile {
                        ParseAPI.sharedInstance().getCurrentLocation(completionHandler: { (result, error) in
                            if let result = result {
                                print(result)
                                ParseAPI.sharedInstance().save(data["first_name"]! as! String, last_name: data["last_name"]! as! String, birthday: data["birthday"]! as! String, email: data["email"]! as! String, gender: data["gender"]! as! String, geoPoint: result, facebookPhoto: imageFile, completionHandler: { (success, error) in
                                    if success == true {
                                        self.presentLoggedInAlert()
                                    } else {
                                        print("Error: Parse could not save")
                                    }
                                })
                            }
                        })
                            }
                        })
                    }
                })
            }
        } else {
            if (FBSDKAccessToken.current() != nil)
            {
                activityIndicator.startAnimating()
                // Since we already logged in we can display the user datea and taggable friend data.
                FacebookAPI.sharedInstance().showUserData(completionHandler: { (data, error) in
                    if let data = data {
                        FacebookAPI.sharedInstance().getFBPhoto(facebookID: data["id"] as! String, completionHandler: { (imageFile, error) in
                            if let imageFile = imageFile {
                                ParseAPI.sharedInstance().getCurrentLocation(completionHandler: { (result, error) in
                                    if let result = result {
                                        print(result)
                                        ParseAPI.sharedInstance().save(data["first_name"]! as! String, last_name: data["last_name"]! as! String, birthday: data["birthday"]! as! String, email: data["email"]! as! String, gender: data["gender"]! as! String, geoPoint: result, facebookPhoto: imageFile, completionHandler: { (success, error) in
                                            if success == true {
                                                self.presentLoggedInAlert()
                                            } else {
                                                print("Error: Parse could not save")
                                            }
                                        })
                                    }
                                })
                            }
                        })
                    }
                })
            }
        }
    }
    
    func log(_ logInController: PFLogInViewController, didLogIn user: PFUser) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        self.dismiss(animated: true, completion: nil)
        presentLoggedInAlert()
    }
    
    func presentLoggedInAlert() {
        let alertController = UIAlertController(title: "You're logged in", message: "Welcome to Blind Box", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.performSegue(withIdentifier: "lol", sender: self)
        }
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
