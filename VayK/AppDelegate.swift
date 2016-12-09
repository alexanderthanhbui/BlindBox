//
//  AppDelegate.swift
//  VayK
//
//  Created by Hayne Park on 11/28/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit
import ParseTwitterUtils
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func checkIfFirstLaunch() {
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") {
            print("App has launched before")
        } else {
            print("This is the first launch ever!")
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            UserDefaults.standard.set(18.0, forKey: "min_age_slider_value")
            UserDefaults.standard.set(65.0, forKey: "max_age_slider_value")
            UserDefaults.standard.set(50.0, forKey: "slider_value")
            UserDefaults.standard.set(0.0, forKey: "min_timeline_slider_value")
            UserDefaults.standard.set(0.0, forKey: "max_timeline_slider_value")
            UserDefaults.standard.set(2.0, forKey: "min_blindbox_slider_value")
            UserDefaults.standard.set(10.0, forKey: "max_blindbox_slider_value")
            UserDefaults.standard.set(3, forKey: "createGender")
            UserDefaults.standard.set(2, forKey: "Gender")
            UserDefaults.standard.set(2, forKey: "lastSelection")
            UserDefaults.standard.set(2, forKey: "create_blindbox_size_slider_value")
            UserDefaults.standard.set(18, forKey: "create_blindbox_min_age_slider_value")
            UserDefaults.standard.set(65, forKey: "create_blindbox_max_age_slider_value")
            UserDefaults.standard.set(4, forKey: "createLastSelection")
            UserDefaults.standard.set(10, forKey: "categoryLastSelection")
            UserDefaults.standard.set(9, forKey: "createCategory")
            UserDefaults.standard.synchronize()
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        checkIfFirstLaunch()
        //Parse.setApplicationId("rC8XAopwWJ", clientKey:"qyijrz9H5D")
        Parse.setLogLevel(PFLogLevel.info);
        Parse.enableLocalDatastore()

        let config = ParseClientConfiguration(block: {
        (ParseMutableClientConfiguration) -> Void in

        ParseMutableClientConfiguration.applicationId = "MrFF6pmuI0ibpUheixmd";
        ParseMutableClientConfiguration.clientKey = "xp1zvlaIeGCLCtMvaRuV";
        ParseMutableClientConfiguration.server = "https://blindbox.herokuapp.com/parse";
            UITabBar.appearance().tintColor = UIColor(red: 242.0/255.0, green:
                116.0/255.0, blue: 119.0/255.0, alpha: 1.0)
            UINavigationBar.appearance().barTintColor = UIColor.white
            UINavigationBar.appearance().tintColor = UIColor(red: 242.0/255.0, green:
                116.0/255.0, blue: 119.0/255.0, alpha: 1.0)
            if let barFont = UIFont(name: "Helvetica", size: 18.0) {
                UINavigationBar.appearance().titleTextAttributes =
                    [NSForegroundColorAttributeName:UIColor.darkGray,
                NSFontAttributeName:barFont]
            }
        })
        Parse.initialize(with: config)
        PFTwitterUtils.initialize(withConsumerKey: "cPk81ls5RM", consumerSecret:"cPk81ls5RM")
        PFFacebookUtils.initializeFacebook(applicationLaunchOptions: launchOptions)
        
        if application.responds(to: #selector(UIApplication.registerUserNotificationSettings(_:))) {
            let userNotificationTypes: UIUserNotificationType = ([UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound])
            
            let settings = UIUserNotificationSettings(types: userNotificationTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }
    
    // Mark - Push Notification methods
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let installation = PFInstallation.current()
        installation?.setDeviceTokenFrom(deviceToken)
        installation?.saveInBackground { (succeeed: Bool, error: Error?) -> Void in
            if error != nil {
                print("didRegisterForRemoteNotificationsWithDeviceToken")
                print(error)
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError")
        print(error)
    }
    
    // TODO: Rewrite this method with notifications
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        //        let delay = 4.0 * Double(NSEC_PER_SEC)
        //        var time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        //        dispatch_after(time, dispatch_get_main_queue()) { () -> Void in
        //            MessagesViewController.refreshMessagesView()
        //        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadMessages"), object: nil)
    }


}

