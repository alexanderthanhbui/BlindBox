//
//  BlindBoxCollectionViewController.swift
//  VayK
//
//  Created by Hayne Park on 6/29/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import Foundation
import UIKit

class BlindBoxTableViewController : UITableViewController, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate {
        
    var users = [PFUser]()
    let model = generateRandomData()
    var storedOffsets = [Int: CGFloat]()
        
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
    
    var collectionViewLayout: CustomImageFlowLayout!
    var collectionView2Layout: CustomImage2FlowLayout!
    var searchController: UISearchController!
    
    func searchUsers(searchLower: String) {
        let user = PFUser.currentUser()
        let query = PFQuery(className: PF_USER_CLASS_NAME)
        query.whereKey(PF_USER_OBJECTID, notEqualTo: user!.objectId!)
        query.whereKey(PF_USER_FULLNAME_LOWER, containsString: searchLower)
        query.orderByAscending(PF_USER_FULLNAME)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.users.removeAll(keepCapacity: false)
                self.users += objects as! [PFUser]!
                self.tableView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
            }
            
        }
    }
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        performSegueWithIdentifier("lol", sender: self)
        return true
    }

    func updateSearchResultsForSearchController(searchController: UISearchController) {
        // If dismissed then no update
        if !searchController.active {
            return
        }
        
        // Write some code for autocomplete (or ignore next fonction and directly process your data hère and siplay it in the SearchTableViewController)
        searchUsers(searchController.searchBar.text!)        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        if let search = searchController.searchBar.text {
            // Load your results in SearchTableViewController
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row == 0
        {
            return 150
        }
        if indexPath.row == 1
        {
            return 44
        }
        if indexPath.row == 2
        {
            return 125
        }
        if indexPath.row == 3
        {
            return 44
        }
        if indexPath.row == 4
        {
            return 375
        }
        let height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        return height
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier("blindBoxFirstCustomCell",
                forIndexPath: indexPath) as! BlindBoxFirstCustomTableViewCell
            //set the data here
            return cell
        }
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier("blindBoxSecondCustomCell",
                forIndexPath: indexPath) as! BlindBoxSecondCustomTableViewCell
            //set the data here
            return cell
        }
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier("blindBoxFourthCustomCell",
                forIndexPath: indexPath) as! BlindBoxFourthCustomTableViewCell
            //set the data here
            return cell
        }
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier("blindBoxThirdCustomCell", forIndexPath: indexPath) as! ProfileTableViewCell
        collectionViewLayout = CustomImageFlowLayout()
        cell.collectionView.collectionViewLayout = collectionViewLayout
        cell.contentView.tag == 0

        return cell
        }
        if indexPath.row == 4 {
            let cell = tableView.dequeueReusableCellWithIdentifier("blindBoxFifthCustomCell", forIndexPath: indexPath) as! Profile2TableViewCell
            collectionView2Layout = CustomImage2FlowLayout()
            cell.topCategoriesView.collectionViewLayout = collectionView2Layout
            cell.contentView.tag == 1
            return cell
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("lol", forIndexPath: indexPath) as! Profile2TableViewCell
        return cell

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let src = SearchTableViewController() //A simple UiTableViewController I instanciated in the storyboard
        
        // We instanciate our searchController with the searchResultTCV (we he will display the result
        searchController = UISearchController(searchResultsController: src)
        
        // Self is responsible for updating the contents of the search results controller
        searchController.searchResultsUpdater = self
        
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        // Dim the current view when you sélect eh search bar (anyway will be hidden when the user type something)
        searchController.dimsBackgroundDuringPresentation = true
        
        // Prevent the searchbar to disapear during search
        self.searchController.hidesNavigationBarDuringPresentation = false
        
        // Include the search controller's search bar within the table's header view
        navigationItem.titleView = searchController.searchBar
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        
        definesPresentationContext = true
        
        for family: String in UIFont.familyNames()
        {
            print("\(family)")
            for names: String in UIFont.fontNamesForFamilyName(family)
            {
                print("== \(names)")
            }
        }
        let defaults = NSUserDefaults.standardUserDefaults()
        let hasViewedWalkthrough = defaults.boolForKey("hasViewedWalkthrough")
        if hasViewedWalkthrough {
            return
        }
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "BlindBoxMode")
        NSUserDefaults.standardUserDefaults().setFloat(18.0, forKey: "min_age_slider_value")
        NSUserDefaults.standardUserDefaults().setFloat(65.0, forKey: "max_age_slider_value")
        NSUserDefaults.standardUserDefaults().setFloat(50.0, forKey: "slider_value")
        NSUserDefaults.standardUserDefaults().setFloat(0.0, forKey: "min_timeline_slider_value")
        NSUserDefaults.standardUserDefaults().setFloat(0.0, forKey: "max_timeline_slider_value")
        NSUserDefaults.standardUserDefaults().setFloat(0.0, forKey: "min_blindbox_slider_value")
        NSUserDefaults.standardUserDefaults().setFloat(10.0, forKey: "max_blindbox_slider_value")
        NSUserDefaults.standardUserDefaults().setInteger(3, forKey: "createGender")
        NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "Gender")
        NSUserDefaults.standardUserDefaults().setInteger(2, forKey: "lastSelection")
        NSUserDefaults.standardUserDefaults().setInteger(4, forKey: "createLastSelection")
        NSUserDefaults.standardUserDefaults().setInteger(10, forKey: "categoryLastSelection")
        NSUserDefaults.standardUserDefaults().setInteger(9, forKey: "createCategory")
        if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("WalkthroughController") as? WalkthroughPageViewController {
            presentViewController(pageViewController, animated: true, completion: nil)
        }
    }

}

extension BlindBoxTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
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
        print("Collection view at row \(collectionView.tag) selected index path \(indexPath)")
    }
}
