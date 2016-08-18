//
//  AppDelegate.swift
//  VayK
//
//  Created by Matthew Goldspink on 8/26/15.
//  Copyright (c) 2015 mgoldspink. All rights reserved.
//

import UIKit
import ParseTwitterUtils
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        //Parse.setApplicationId("rC8XAopwWJ", clientKey:"qyijrz9H5D")
        Parse.setLogLevel(PFLogLevel.Info);
        Parse.enableLocalDatastore()

        let config = ParseClientConfiguration(block: {
        (ParseMutableClientConfiguration) -> Void in

        ParseMutableClientConfiguration.applicationId = "MrFF6pmuI0ibpUheixmd";
        ParseMutableClientConfiguration.clientKey = "xp1zvlaIeGCLCtMvaRuV";
        ParseMutableClientConfiguration.server = "https://blindbox.herokuapp.com/parse";
            UITabBar.appearance().tintColor = UIColor(red: 242.0/255.0, green:
                116.0/255.0, blue: 119.0/255.0, alpha: 1.0)
            UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
            UINavigationBar.appearance().tintColor = UIColor(red: 242.0/255.0, green:
                116.0/255.0, blue: 119.0/255.0, alpha: 1.0)
            if let barFont = UIFont(name: "Helvetica", size: 18.0) {
                UINavigationBar.appearance().titleTextAttributes =
                    [NSForegroundColorAttributeName:UIColor.darkGrayColor(),
                NSFontAttributeName:barFont]
            }
});

Parse.initializeWithConfiguration(config);
        PFTwitterUtils.initializeWithConsumerKey("cPk81ls5RM", consumerSecret:"cPk81ls5RM")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions);
        
        if application.respondsToSelector(Selector("registerUserNotificationSettings:")) {
            let userNotificationTypes: UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound])
            
            let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    // Mark - Push Notification methods
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackgroundWithBlock { (succeeed: Bool, error: NSError?) -> Void in
            if error != nil {
                print("didRegisterForRemoteNotificationsWithDeviceToken")
                print(error)
            }
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("didFailToRegisterForRemoteNotificationsWithError")
        print(error)
    }
    
    // TODO: Rewrite this method with notifications
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        //        let delay = 4.0 * Double(NSEC_PER_SEC)
        //        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        //        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
        //            MessagesViewController.refreshMessagesView()
        //        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("reloadMessages", object: nil)
    }


}

