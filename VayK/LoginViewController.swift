//
//  LoginViewController.swift
//  VayK
//
//  Created by Hayne Park on 11/28/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class LoginViewController : PFLogInViewController {
    
    var backgroundImage : UIImageView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set our custom background image
        backgroundImage = UIImageView(image: UIImage(named: "welcome_bg"))
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.logInView!.insertSubview(backgroundImage, at: 0)
        
        // remove the parse Logo
        let logo = UILabel()
        logo.text = "Blind Box"
        logo.textColor = UIColor.white
        logo.font = UIFont(name: "GothamRounded-Medium", size: 40)
        logo.shadowColor = UIColor.lightGray
        logo.shadowOffset = CGSize(width: 2, height: 2)
        logInView?.logo = logo
        
        // position logo at top with larger frame
        logInView!.logo!.sizeToFit()
        let logoFrame = logInView!.logo!.frame
        logInView!.logo!.frame = CGRect(x: logoFrame.origin.x, y: logInView!.frame.origin.y - logoFrame.height - 16, width: logInView!.frame.width,  height: logoFrame.height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // stretch background image to fill screen
        backgroundImage.frame = CGRect( x: 0,  y: 0,  width: self.logInView!.frame.width,  height: self.logInView!.frame.height)
    }
    
}
