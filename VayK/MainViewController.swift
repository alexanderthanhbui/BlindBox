//
//  MainViewController.swift
//  VayK
//
//  Created by Hayne Park on 11/28/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate, UIAlertViewDelegate {
    
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 15
    let userObjectID = PFUser.current()!.objectId!
    let userIDArray = [PFUser.current()!.objectId!]
    
    @IBAction func segmentedControlValueChanged(_ sender: AnyObject) {
        if(segmentedControl.selectedSegmentIndex == 0)
        {
            let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
            query.whereKey(PF_GROUPS_POINTER, notContainedIn:userIDArray)
            query.whereKey(PF_GROUPS_FULL, notEqualTo: true)
            query.order(byDescending: PF_CHAT_CREATEDAT)
            query.findObjectsInBackground{ (objects: [PFObject]?, error: Error?) -> Void in
                if error == nil {
                    self.groups.removeAll()
                    self.groups.append(contentsOf: objects as [PFObject]!)
                    self.tableView.reloadData()
                    self.updateEmptyView()
                } else {
                    print("error")
                }
            }
        }
        else if(segmentedControl.selectedSegmentIndex == 1)
        {
            let user = PFUser.current()
            let userGeoPoint = user![PF_USER_LOCATION] as! PFGeoPoint
            let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
            query.whereKey(PF_GROUPS_POINTER, notContainedIn:userIDArray)
            query.whereKey(PF_GROUPS_FULL, notEqualTo: true)
            query.whereKey(PF_GROUPS_LOCATION, nearGeoPoint:userGeoPoint)
            query.findObjectsInBackground{ (objects: [PFObject]?, error: Error?) -> Void in
                if error == nil {
                    self.groups.removeAll()
                    self.groups.append(contentsOf: objects as [PFObject]!)
                    self.tableView.reloadData()
                    self.updateEmptyView()
                } else {
                    print("error1")
                }
            }
        }
        else if(segmentedControl.selectedSegmentIndex == 2)
        {
            let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
            query.whereKey(PF_GROUPS_POINTER, notContainedIn:userIDArray)
            query.whereKey(PF_GROUPS_FULL, notEqualTo: true)
            query.order(byAscending: PF_GROUPS_TIMELINE)
            query.findObjectsInBackground{ (objects: [PFObject]?, error: Error?) -> Void in
                if error == nil {
                    self.groups.removeAll()
                    self.groups.append(contentsOf: objects as [PFObject]!)
                    self.tableView.reloadData()
                    self.updateEmptyView()
                } else {
                    print("error2")
                }
            }
        }
    }
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet var emptyView: UIView!
    
    var users = [PFUser]()
    var groups: [PFObject]! = []
    
    @IBOutlet var tableView: UITableView!
    
    var searchController: UISearchController!
    
    func searchUsers(_ searchLower: String) {
        let user = PFUser.current()
        let query = PFQuery(className: PF_USER_CLASS_NAME)
        query.whereKey(PF_USER_OBJECTID, notEqualTo: user!.objectId!)
        query.whereKey(PF_USER_FIRSTNAME_LOWER, contains: searchLower)
        query.order(byAscending: PF_USER_FIRSTNAME)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                self.users.removeAll(keepingCapacity: false)
                self.users += objects as! [PFUser]!
                self.tableView.reloadData()
            } else {
                ProgressHUD.showError("Network error")
            }
            
        }
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        performSegue(withIdentifier: "lol", sender: self)
        return true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If dismissed then no update
        if !searchController.isActive {
            return
        }
        
        // Write some code for autocomplete (or ignore next fonction and directly process your data hère and siplay it in the SearchTableViewController)
        searchUsers(searchController.searchBar.text!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let search = searchController.searchBar.text {
            // Load your results in SearchTableViewController
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = hexStringToUIColor("#f5f5f5")
        self.view.backgroundColor = hexStringToUIColor("#f5f5f5")
        self.segmentedControl.backgroundColor = UIColor.white
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16.0),NSForegroundColorAttributeName:hexStringToUIColor("#333333")], for:UIControlState())
        
        self.segmentedControl.setTitleTextAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 16.0),NSForegroundColorAttributeName:UIColor(red: 242.0/255.0, green: 116.0/255.0, blue: 119.0/255.0, alpha: 1.0)], for:UIControlState.selected)
        
        self.segmentedControl.setDividerImage(self.imageWithColor(UIColor.clear), forLeftSegmentState: UIControlState(), rightSegmentState: UIControlState(), barMetrics: UIBarMetrics.default)
        
        self.segmentedControl.setBackgroundImage(self.imageWithColor(UIColor.clear), for:UIControlState(), barMetrics:UIBarMetrics.default)
        
        self.segmentedControl.setBackgroundImage(self.imageWithColor(UIColor(red: 242.0/255.0, green: 116.0/255.0, blue: 119.0/255.0, alpha: 1.0)), for:UIControlState.selected, barMetrics:UIBarMetrics.default);
        
        for borderview in self.segmentedControl.subviews {
            
            let upperBorder: CALayer = CALayer()
            upperBorder.backgroundColor = UIColor.lightGray.cgColor
            upperBorder.frame = CGRect(x: 0, y: borderview.frame.size.height+21, width: borderview.frame.size.width, height: 0.5);
            borderview.layer .addSublayer(upperBorder);
            
        }
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
        searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        
        definesPresentationContext = true
        
        NotificationCenter.default.addObserver(self, selector: "cleanup", name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGGED_OUT), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: "loadGroups", name: NSNotification.Name(rawValue: "reloadMessages"), object: nil)
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(loadGroups(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        self.emptyView?.isHidden = true
    }
    
    func loadGroups(_ refreshControl: UIRefreshControl) {
        let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
        query.findObjectsInBackground{ (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                self.groups.removeAll()
                self.groups.append(contentsOf: objects as [PFObject]!)
                self.tableView.reloadData()
                self.updateEmptyView()
            } else {
                ProgressHUD.showError("Network error")
                print(error)
            }
            refreshControl.endRefreshing()
        }
    }
    
    func imageWithColor(_ color: UIColor) -> UIImage {
        
        let rect = CGRect(x: 0.0, y: 48.0, width: 1.0, height: 50.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
        query.whereKey(PF_GROUPS_POINTER, notContainedIn:userIDArray)
        query.findObjectsInBackground{ (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                self.groups.removeAll()
                self.groups.append(contentsOf: objects as [PFObject]!)
                self.tableView.reloadData()
                self.updateEmptyView()
            } else {
                ProgressHUD.showError("Network error")
                print(error)
            }
        }
    }
    
    func hexStringToUIColor (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: (NSCharacterSet.whitespacesAndNewlines as NSCharacterSet) as CharacterSet).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // MARK: - Helper methods
    
    func updateEmptyView() {
        self.emptyView?.isHidden = (self.groups.count != 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View delegate methods
    
    // have one section for every array item
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.groups.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 155
    }
    
    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    // Make the background color show through
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = hexStringToUIColor("#f5f5f5")
        self.tableView.tableHeaderView = headerView
        return headerView
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! GroupsTableViewCell
        
        let group = self.groups[(indexPath as NSIndexPath).section]
        cell.titleLabel.text = group[PF_GROUPS_NAME] as? String
        
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
        updatedFormatter.dateFormat = "EEEE"
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
            cell.detailLabel.text = "Today at " + justTime + " · " + city!
        } else if updatedTestInt == testForTomorrowInt {
            cell.detailLabel.text = "Tomorrow at " + justTime + " · " + city!
        } else {
            cell.detailLabel.text = op + " at " + justTime + " · " + city!
        }
        
        let updatedDayFormatter = DateFormatter()
        updatedDayFormatter.dateFormat = "d"
        let updatedDay = updatedDayFormatter.string(from: morningOfChristmas)
        
        let updatedMonthFormatter = DateFormatter()
        updatedMonthFormatter.dateFormat = "MMM"
        let updatedMonth = updatedMonthFormatter.string(from: morningOfChristmas).uppercased()
        
        cell.dateLabel.text = updatedDay
        cell.monthLabel.text = updatedMonth
        
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = hexStringToUIColor("#cccccc").cgColor
        border.frame = CGRect(x: 0, y: cell.layer.frame.size.height - width, width: cell.layer.frame.size.width, height: cell.layer.frame.size.height)
        
        border.borderWidth = width
        cell.layer.addSublayer(border)
        cell.layer.masksToBounds = true
        
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
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
            let group = self.groups[(indexPath as NSIndexPath).section]
            let groupId = group.objectId! as String
          //print(groupId)
            
            Messages.createMessageItem(PFUser(), groupId: groupId, description: group[PF_GROUPS_NAME] as! String)
        
        let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
        query.getObjectInBackground(withId: groupId) {
            (gameScore: PFObject?, error: Error?) -> Void in
            if error != nil {
                print(error)
            } else if let gameScore = gameScore {
                let playerName = gameScore[PF_GROUPS_POINTER] as! NSMutableArray
                print("\(playerName.count) old count")
                let groupSize = gameScore[PF_GROUPS_SIZE] as! Int
                playerName.add(self.userObjectID)
                gameScore[PF_GROUPS_POINTER] = playerName
                print("\(playerName.count) new count")
                if playerName.count == groupSize {
                    gameScore[PF_GROUPS_FULL] = true
                    gameScore.saveInBackground()
                } else {
                    gameScore.saveInBackground()
                }
            }
        }
            self.performSegue(withIdentifier: "too", sender: groupId)
    }
}
