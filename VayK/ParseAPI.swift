//
//  ParseAPI.swift
//  VayK
//
//  Created by Hayne Park on 11/28/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import Foundation
import Parse

class ParseAPI : NSObject  {
    
    func getCurrentLocation(completionHandler: @escaping (_ result: PFGeoPoint?, _ error: NSError?) -> Void) {
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error ) -> Void in
            if let geoPoint = geoPoint {
                completionHandler(geoPoint, nil)
            } else {
                print("Error parsing user's location")
            }
        }
    }
    
    func save(_ first_name: String?, last_name: String?, birthday: String?, email: String?, gender: String?, geoPoint: PFGeoPoint?, facebookPhoto: PFFile?, completionHandler: @escaping (_ success: Bool?, _ error: NSError?) -> Void) {
        
        PFUser.current()?[PF_USER_FIRSTNAME] = first_name
        PFUser.current()?[PF_USER_FIRSTNAME_LOWER] = first_name?.lowercased()
        PFUser.current()?[PF_USER_LASTNAME] = last_name
        PFUser.current()?[PF_USER_BIRTHDAY] = birthday
        PFUser.current()?[PF_USER_EMAIL] = email
        PFUser.current()?[PF_USER_GENDER] = gender
        PFUser.current()?[PF_USER_LOCATION] = geoPoint
        PFUser.current()?[PF_USER_PICTURE] = facebookPhoto
        PFUser.current()?.saveInBackground { (success: Bool, error: Error?) -> Void in
            if (success) {
                // The object has been saved.
                print("yay")
                completionHandler(true, nil)
            } else {
                // There was a problem, check error.description
                print("error")
            }
        }
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseAPI {
        struct Singleton {
            static var sharedInstance = ParseAPI()
        }
        return Singleton.sharedInstance
    }
}
