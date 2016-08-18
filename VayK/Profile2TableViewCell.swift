//
//  Profile2TableViewCell.swift
//  VayK
//
//  Created by Hayne Park on 7/12/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit

class Profile2TableViewCell: UITableViewCell {

    @IBOutlet var topCategoriesView: UICollectionView!
    
    var recipeImages = ["arts", "yoga", "education",
        "full_breakfast", "green_tea", "ft", "ham_and_egg_sandwich",
        "socials", "sports"]
    
    var categoryImages = [""]
    var categoryNames = ["Arts", "Classes", "Education", "Food & Drinks", "Misc.", "Music", "Networking", "Social", "Sports"]
    
}

extension Profile2TableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! ExploreCollectionViewCell
        
        cell.imageView.image = UIImage(named: recipeImages[indexPath.row])
        cell.label.text = categoryNames[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}