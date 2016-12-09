//
//  SearchTableViewController.swift
//  VayK
//
//  Created by Hayne Park on 7/18/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit
import CoreLocation
import AddressBookUI

protocol SearchTableViewControllerDelegate {
    func didSearchUser(_ user: PFUser)
}

class SearchTableViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, CLLocationManagerDelegate {
    
    let user = PFUser.current()
    let userIDArray = [PFUser.current()!.objectId!]

    var timeCreated = [Date]()
    var locationManager = CLLocationManager()
    
    @IBAction func unwindToSearch(_ segue: UIStoryboardSegue) {
        let calendar = Calendar.current
        let rightNow = Date()
        
        // If user cancels reset dateData to "Today"
        UserDefaults.standard.set(0, forKey: "create_blindbox_day_value")
        
        // Round current hour to the next 12 hour
        let currentHour = calendar.component(.hour, from: rightNow)
        print(currentHour)
        
        // Round minutes to the next 5 minutes
        let minuteInterval = 5
        let nextMinuteDiff = minuteInterval - calendar.component(.minute, from: rightNow) % minuteInterval
        let nextMinuteDate = calendar.date(byAdding: .minute, value: nextMinuteDiff, to: rightNow) ?? Date()
        let minutes = calendar.component(.minute, from: nextMinuteDate as Date)
        UserDefaults.standard.set(minutes, forKey: "create_blindbox_minute_value")
        print(minutes)
        
        if minutes == 60 {
        if currentHour >= 12 || currentHour != 23 {
            // Subtract 12 to match index.row in hourData array in AddTableViewController
            let nextHourDate = currentHour - 11
            UserDefaults.standard.set(nextHourDate, forKey: "create_blindbox_hour_value")
            print("hour 1")
        } else if currentHour == 23 {
            let nextHourDate = currentHour - 23
            UserDefaults.standard.set(nextHourDate, forKey: "create_blindbox_hour_value")
            print("hour 2")
        } else {
            let nextHourDate = currentHour + 1
            UserDefaults.standard.set(nextHourDate, forKey: "create_blindbox_hour_value")
            print("hour 3")
            }
        } else {
            if currentHour >= 12 {
                // Subtract 12 to match index.row in hourData array in AddTableViewController
                let nextHourDate = currentHour - 12
                UserDefaults.standard.set(nextHourDate, forKey: "create_blindbox_hour_value")
                print("hour 4")
            } else {
                UserDefaults.standard.set(currentHour, forKey: "create_blindbox_hour_value")
                print("hour 5")
            }
        }
        
        // Detemine AM or PM depending on currentHour
        if currentHour >= 12 {
            UserDefaults.standard.set(1, forKey: "create_blindbox_meridiem_value")
        } else {
            UserDefaults.standard.set(0, forKey: "create_blindbox_meridiem_value")
        }

        UserDefaults.standard.set(4, forKey: "createLastSelection")
        UserDefaults.standard.set(10, forKey: "categoryLastSelection")
        UserDefaults.standard.set(3, forKey: "createGender")
        UserDefaults.standard.set(9, forKey: "createCategory")
        UserDefaults.standard.set(0, forKey: "create_blindbox_timeline_slider_value")
        UserDefaults.standard.set(2, forKey: "create_blindbox_size_slider_value")
        UserDefaults.standard.set(18, forKey: "create_blindbox_min_age_slider_value")
        UserDefaults.standard.set(65, forKey: "create_blindbox_max_age_slider_value")
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
        searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        
        self.definesPresentationContext = true
    }
    
    func searchUsers(_ searchLower: String) {
        let user = PFUser.current()
        let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
        //query.whereKey(PF_USER_OBJECTID, notEqualTo: user!.objectId!)
        query.whereKey(PF_GROUPS_POINTER, notContainedIn:userIDArray)
        query.whereKey(PF_GROUPS_FULL, notEqualTo: true)
        query.whereKey(PF_GROUPS_POINTER, notContainedIn:userIDArray)
        query.whereKey(PF_GROUPS_NAME_LOWER, contains: searchLower)
        query.order(byAscending: PF_GROUPS_NAME)
        self.searchActive = true
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                self.groups.removeAll(keepingCapacity: false)
                self.groups.append(contentsOf: objects as [PFObject]!)
                self.tableView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
            }
            
        }
        self.searchActive = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchController.isActive = true
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        print("Get GPS")
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint, error ) -> Void in
            if error == nil {
                self.user!["Location"] = geoPoint
                self.user!.saveInBackground()
                print(geoPoint)
            } else {
                print(error) //No error either
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Force search if user pushes button
        let searchLower: String = searchBar.text!.lowercased()
        if (searchLower != "") {
            searchUsers(searchLower)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchController.isActive = false
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        
        UIView.animate(withDuration: 0.0000001, animations: { () -> Void in }, completion: { (completed) -> Void in
            
            searchController.searchBar.becomeFirstResponder()
        }) 
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchLower: String = searchController.searchBar.text!.lowercased()
        if (searchLower != "" && !self.searchActive) {
            searchUsers(searchLower)
        }
        if searchLower.isEmpty {
            let user = PFUser.current()
            let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
            //query.whereKey(PF_USER_OBJECTID, notEqualTo: user!.objectId!)
            query.whereKey(PF_GROUPS_NAME_LOWER, contains: "weirdbugthatnoonewilleverfindoutayelmaoooo123456789!@#$%^&*")
            query.whereKey(PF_GROUPS_FULL, notEqualTo: true)
            query.order(byAscending: PF_GROUPS_NAME)
            query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
                if error == nil {
                    self.groups.removeAll()
                    self.groups.append(contentsOf: objects as [PFObject]!)
                    self.tableView.reloadData()
                } else {
                    ProgressHUD.showError("Network error")
                }
                
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if groups.count == 0 {
            return 1
        } else {
        return self.groups.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        
        if groups.count == 0 {
            cell.titleLabel?.text = "Create a BlindBox"
            cell.detailTitleLabel?.text = "Time · Place · Location"
        } else {
        let group = self.groups[(indexPath as NSIndexPath).row]
            cell.titleLabel?.text = group[PF_GROUPS_NAME] as? String
            
            let city = group[PF_GROUPS_CITY] as? String
            let timeline = group[PF_GROUPS_TIMELINE] as? Date
            
            let date = Date()
            
            let yearFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            let year = yearFormatter.string(from: timeline!)
            //dateString now contains the string ex."1987".
            
            let monthFormatter = DateFormatter()
            monthFormatter.dateFormat = "MM"
            let month = monthFormatter.string(from: timeline!)
            //dateString now contains the string "Aug".
            
            let dayOfWeekFormatter = DateFormatter()
            dayOfWeekFormatter.dateFormat = "eee"
            let dayOfWeek = dayOfWeekFormatter.string(from: timeline!)
            //dateString now contains the string ex."Fri".
            
            let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "d"
            let day = dayFormatter.string(from: timeline!)
            //dateString now contains the string ex."7".
            
            let hourFormatter = DateFormatter()
                hourFormatter.dateFormat = "H"
            let hour = hourFormatter.string(from: timeline!)
            //dateString now contains the string ex."8".
            
            let minuteFormatter = DateFormatter()
            minuteFormatter.dateFormat = "mm"
            let minute = minuteFormatter.string(from: timeline!)
            //dateString now contains the string ex."7".
            
            let secondFormatter = DateFormatter()
            secondFormatter.dateFormat = "sss"
            let second = secondFormatter.string(from: timeline!)
            //dateString now contains the string ex."987".
            
            let yearInt = Int(year)
            let monthInt = Int(month)
            let dateInt = Int(day)
            let hourInt = Int(hour)
            let minuteInt = Int(minute)
            let secondInt = Int(second)
            
            var morningOfChristmasComponents = DateComponents()
            morningOfChristmasComponents.year = yearInt!
            morningOfChristmasComponents.month = monthInt!
            morningOfChristmasComponents.day = dateInt!
            morningOfChristmasComponents.hour = hourInt!
            morningOfChristmasComponents.minute = minuteInt!
            morningOfChristmasComponents.second = secondInt!
            
            let morningOfChristmas = Calendar.current.date(from: morningOfChristmasComponents)!
            
            let updatedFormatter = DateFormatter()
            updatedFormatter.dateFormat = "EEEE, MMM d · h:mm a"
            let op = updatedFormatter.string(from: morningOfChristmas)
            
            let justTimeFormatter = DateFormatter()
            justTimeFormatter.dateFormat = "h:mm a"
            let justTime = justTimeFormatter.string(from: morningOfChristmas)
            
            let updatedTestFormatter = DateFormatter()
            updatedTestFormatter.dateFormat = "d"
            let updatedTest = updatedTestFormatter.string(from: morningOfChristmas)
            let updatedTestInt = Int(updatedTest)

            
            let testForTodayFormatter = DateFormatter()
            testForTodayFormatter.dateFormat = "d"
            let test = testForTodayFormatter.string(from: date)
            let testInt = Int(test)
            
            let testForTomorrowInt = ((Int(test))!+1)
            
            if updatedTestInt == testInt {
                cell.detailTitleLabel?.text = "Today at " + justTime + " · " + city!
            } else if updatedTestInt == testForTomorrowInt {
                cell.detailTitleLabel?.text = "Tomorrow at " + justTime + " · " + city!
            } else {
                cell.detailTitleLabel?.text = op + " · " + city!
            }
            
            /***** NSDateFormatter Part *****/
            
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.long
            formatter.timeStyle = .medium
            
            let dateString = formatter.string(from: morningOfChristmas)
            //dateString now contains the string:
            //  "December 25, 2016 at 7:00:00 AM"
            

        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "too" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            chatVC.groupId = groupId
        }
    }
    
    func openChat(_ groupId: String) {
        self.performSegue(withIdentifier: "too", sender: groupId)
    }
    
    func didSearchUser(_ user2: PFUser) {
        let user1 = PFUser.current()
        let groupId = Messages.startPrivateChat(user1!, user2: user2)
        self.openChat(groupId)
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if groups.count == 0 {
            performSegue(withIdentifier: "createNewBlindBox", sender: self)
        }
        if groups.count >= 1 {
            self.dismiss(animated: true, completion: { () -> Void in
                let group = self.groups[(indexPath as NSIndexPath).row]
                let groupId = group.objectId! as String
                
                Messages.createMessageItem(PFUser(), groupId: groupId, description: group[PF_GROUPS_NAME] as! String)
                
                self.performSegue(withIdentifier: "too", sender: groupId)

            })
        }
    }
}
