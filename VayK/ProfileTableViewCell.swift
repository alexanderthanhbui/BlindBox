//
//  ProfileTableViewCell.swift
//  VayK
//
//  Created by Hayne Park on 6/29/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet var collectionView: UICollectionView!
    
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

extension ProfileTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ExploreCollectionViewCell
        
        cell.imageView.image = UIImage(named: recipeImages[indexPath.row])
        cell.label.text = recipeNames[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}
