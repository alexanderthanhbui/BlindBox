//
//  PersonTableViewController.swift
//  VayK
//
//  Created by Hayne Park on 6/3/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit

class PersonTableViewController: UITableViewController {

    @IBOutlet var imageView:UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var jobLabel: UILabel!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    let ChoosePersonButtonHorizontalPadding:CGFloat = 80.0
    let ChoosePersonButtonVerticalPadding:CGFloat = 20.0
    
    var id: String!
    var name: String!
    var image: UIImage!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            skipButton.tintColor = UIColor(red: 242.0/255.0, green: 116.0/255.0, blue: 119.0/255.0, alpha: 1.0)
            likeButton.tintColor = UIColor(red: 104.0/255.0, green: 195.0/255.0, blue: 163.0/255.0, alpha: 1.0)
            self.nameLabel.text = name + " ,28"
            self.imageView.image = image
            let query2 = PFQuery(className:"Restaurants")
            query2.whereKey("_id", equalTo: id)
            query2.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects {
                        for object in objects {
                        }
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }

        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }

    
        // MARK: - Action methods
    
        

}
