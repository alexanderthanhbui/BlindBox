//
//  Profile2TableViewCell.swift
//  VayK
//
//  Created by Hayne Park on 7/12/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit

class TrendingNearYouTableViewCell: UITableViewCell {
    
    @IBOutlet var topCategoriesView: UICollectionView!
    
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
    
}

extension TrendingNearYouTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 12
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ExploreCollectionViewCell
        
        cell.imageView.image = UIImage(named: recipeImages[indexPath.row])
        cell.label.text = recipeNames[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var query = PFQuery(className:"BlindBox")
        query.whereKey("SubCategoryName", equalTo:"Sean Plott")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if objects!.count == 0 {
                    var queryCategory = PFObject(className:"BlindBox")
                    queryCategory["SubCategoryName"] = 1337
                    queryCategory["playerName"] = "Sean Plott"
                    queryCategory["cheatMode"] = false
                    queryCategory.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            // The object has been saved.
                        } else {
                            // There was a problem, check error.description
                        }
                    }
                } else{
                
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectId)
                    }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}