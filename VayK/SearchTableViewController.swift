//
//  SearchTableViewController.swift
//  VayK
//
//  Created by Hayne Park on 7/18/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI

protocol SearchTableViewControllerDelegate {
    func didSearchUser(user: PFUser)
}

class SearchTableViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, CLLocationManagerDelegate {
    
    let user = PFUser.currentUser()
    var locationManager = CLLocationManager()
    
    @IBAction func unwindToSearch(segue: UIStoryboardSegue) {
        NSUserDefaults.standardUserDefaults().setInteger(4, forKey: "createLastSelection")
        NSUserDefaults.standardUserDefaults().setInteger(10, forKey: "categoryLastSelection")
        NSUserDefaults.standardUserDefaults().setInteger(3, forKey: "createGender")
        NSUserDefaults.standardUserDefaults().setInteger(9, forKey: "createCategory")
        NSUserDefaults.standardUserDefaults().setInteger(0, forKey: "create_blindbox_timeline_slider_value")
        NSUserDefaults.standardUserDefaults().setInteger(1, forKey: "create_blindbox_size_slider_value")
        NSUserDefaults.standardUserDefaults().setInteger(18, forKey: "create_blindbox_min_age_slider_value")
        NSUserDefaults.standardUserDefaults().setInteger(65, forKey: "create_blindbox_max_age_slider_value")
    }
    
    var groups: [PFObject]! = []
    var delegate: SearchTableViewControllerDelegate!

    var searchActive: Bool = false
    
    var searchController : UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search"

        self.searchController = UISearchController(searchResultsController:  nil)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        
        self.navigationItem.titleView = searchController.searchBar
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        
        self.definesPresentationContext = true
    }
    
    func searchUsers(searchLower: String) {
        let user = PFUser.currentUser()
        let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
        //query.whereKey(PF_USER_OBJECTID, notEqualTo: user!.objectId!)
        query.whereKey(PF_GROUPS_NAME_LOWER, containsString: searchLower)
        query.orderByAscending(PF_GROUPS_NAME)
        self.searchActive = true
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.groups.removeAll(keepCapacity: false)
                self.groups.appendContentsOf(objects as [PFObject]!)
                self.tableView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
            }
            
        }
        self.searchActive = false
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.searchController.active = true
    }
    
    override func viewDidAppear(animated: Bool) {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        print("Get GPS")
        PFGeoPoint.geoPointForCurrentLocationInBackground { (geoPoint, error ) -> Void in
            if error == nil {
                self.user!["Location"] = geoPoint
                self.user!.saveInBackground()
                print(geoPoint)
            } else {
                print(error) //No error either
            }
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        // Force search if user pushes button
        let searchLower: String = searchBar.text!.lowercaseString
        if (searchLower != "") {
            searchUsers(searchLower)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchController.active = false
    }
    
    func didPresentSearchController(searchController: UISearchController) {
        
        UIView.animateWithDuration(0.0000001, animations: { () -> Void in }) { (completed) -> Void in
            
            searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        let searchLower: String = searchController.searchBar.text!.lowercaseString
        if (searchLower != "" && !self.searchActive) {
            searchUsers(searchLower)
        }
        if searchLower.isEmpty {
            let user = PFUser.currentUser()
            let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
            //query.whereKey(PF_USER_OBJECTID, notEqualTo: user!.objectId!)
            query.whereKey(PF_GROUPS_NAME_LOWER, containsString: "weirdbugthatnoonewilleverfindoutayelmaoooo123456789!@#$%^&*")
            query.orderByAscending(PF_GROUPS_NAME)
            query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    self.groups.removeAll()
                    self.groups.appendContentsOf(objects as [PFObject]!)
                    self.tableView.reloadData()
                } else {
                    ProgressHUD.showError("Network error")
                }
                
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if groups.count == 0 {
            return 1
        } else {
        return self.groups.count
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SearchTableViewCell
        
        if groups.count == 0 {
            cell.titleLabel?.text = "Create a BlindBox"
            cell.detailTitleLabel?.text = "Time · Place · Location"
        } else {
        let group = self.groups[indexPath.row]

        cell.titleLabel?.text = group[PF_GROUPS_NAME] as? String
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "too" {
            let chatVC = segue.destinationViewController as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            chatVC.groupId = groupId
        }
    }
    
    func openChat(groupId: String) {
        self.performSegueWithIdentifier("too", sender: groupId)
    }
    
    func didSearchUser(user2: PFUser) {
        let user1 = PFUser.currentUser()
        let groupId = Messages.startPrivateChat(user1!, user2: user2)
        self.openChat(groupId)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if groups.count == 0 {
            performSegueWithIdentifier("createNewBlindBox", sender: self)
        }
        if groups.count >= 1 {
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
                let group = self.groups[indexPath.row]
                let groupId = group.objectId! as String
                
                Messages.createMessageItem(PFUser(), groupId: groupId, description: group[PF_GROUPS_NAME] as! String)
                
                self.performSegueWithIdentifier("too", sender: groupId)

            })
        }
    }
}
