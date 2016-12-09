//
//  FacebookAPI.swift
//  VayK
//
//  Created by Hayne Park on 11/28/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import Foundation

class FacebookAPI : NSObject {

    func showUserData(completionHandler: @escaping (_ results: [String: AnyObject]?, _ error: NSError?) -> Void)
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, email, first_name, last_name, birthday, gender, picture.height(10800).width(10800)"])
        graphRequest.start(completionHandler: { (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
                completionHandler(nil, error as NSError?)
            }
            else
            {
                let data:[String:AnyObject] = result as! [String : AnyObject]
                completionHandler(data, error as NSError?)
            }
        })
    }
    
    func getFBPhoto(facebookID: String, completionHandler: @escaping (_ image: PFFile?, _ error: NSError?) -> Void) {
            // Profile pic
            let imgURLString = "http://graph.facebook.com/\(facebookID)/picture?width=1080"
            let imgURL = NSURL(string: imgURLString)
            let imageData = NSData(contentsOf: imgURL! as URL)
            let image = UIImage(data: imageData! as Data)
            let imageData2 = UIImagePNGRepresentation(image!)
            let imageFile = PFFile(name:"image.png", data:imageData2!)
            completionHandler(imageFile, nil)
    }

// MARK: Shared Instance

class func sharedInstance() -> FacebookAPI {
    struct Singleton {
        static var sharedInstance = FacebookAPI()
    }
    return Singleton.sharedInstance
    }
}
