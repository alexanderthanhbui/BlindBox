//
//  TrendingNearYouTableViewController.swift
//  VayK
//
//  Created by Hayne Park on 7/13/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit

class TrendingNearYouTableViewController: UITableViewController {
    
    var recipeImages = ["angry_birds_cake", "creme_brelee", "egg_benedict",
        "full_breakfast", "green_tea", "ham_and_cheese_panini", "ham_and_egg_sandwich",
        "hamburger", "instant_noodle_with_egg.jpg", "japanese_noodle_with_pork",
        "mushroom_risotto", "noodle_with_bbq_pork", "starbucks_coffee",
        "thai_shrimp_cake", "vegetable_curry", "white_chocolate_donut"]
    
    var recipeNames = ["Sweets", "Dessert", "Brunch",
        "Breakfast", "Tea", "Lunch", "Sandwich",
        "Hamburger", "Noodles", "Ramen",
        "Risotto", "BBQ Pork", "Starbucks",
        "Shrimp Cake", "Curry", "Donut"]
    
    var collectionViewLayout: CustomImageView3FlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
            return 500
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("TrendingNearYouCustomCell", forIndexPath: indexPath) as! TrendingNearYouTableViewCell
            collectionViewLayout = CustomImageView3FlowLayout()
            cell.topCategoriesView.collectionViewLayout = collectionViewLayout
            return cell
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
}

