//
//  GroupViewController.swift
//  SwiftParseChat
//
//  Created by Jesse Hu on 2/20/15.
//  Copyright (c) 2015 Jesse Hu. All rights reserved.
//

import UIKit
// Parse loaded from SwiftParseChat-Bridging-Header.h

class GroupsViewController: UITableViewController, UIAlertViewDelegate {
    
    @IBOutlet var emptyView: UIView!
    
    let cellSpacingHeight: CGFloat = 15
    var groups: [PFObject]! = []
    let userIDArray = [PFUser.current()!.objectId!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: "cleanup", name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGGED_OUT), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(GroupsViewController.loadGroups), name: NSNotification.Name(rawValue: "reloadMessages"), object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(GroupsViewController.loadGroups), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(self.refreshControl!)
        
        self.emptyView?.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if PFUser.current() != nil {
            self.loadGroups()
        }
        else {
            Utilities.loginUser(self)
        }
    }
    
    // MARK: - Helper methods
    
    func updateEmptyView() {
        self.emptyView?.isHidden = (self.groups.count != 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadGroups() {
        let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
        query.whereKey(PF_GROUPS_POINTER, containedIn:userIDArray)
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
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func newButtonPressed(_ sender: UIBarButtonItem) {
        self.actionNew()
    }
    
    func actionNew() {
        let alert = UIAlertView(title: "Please enter a name for your group", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        alert.alertViewStyle = UIAlertViewStyle.plainTextInput
        alert.show()
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            let textField = alertView.textField(at: 0);
            if let text = textField!.text {
                if text.characters.count > 0 {
                    let object = PFObject(className: PF_GROUPS_CLASS_NAME)
                    object[PF_GROUPS_NAME] = text
                    object.saveInBackground(block: { (success: Bool, error: Error?) -> Void in
                        if success {
                            self.loadGroups()
                        } else {
                            ProgressHUD.showError("Network error")
                            print(error)
                        }
                    })
                }
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
    
    // MARK: - TableView Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.groups.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 120
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0) {
            return 44
        } else {
            return cellSpacingHeight
        }
    }
    
    // Make the background color show through
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if(section == 0) {
            let view = UIView() // The width will be the same as the cell, and the height should be set in tableView:heightForRowAtIndexPath:
            let label = UILabel()
            label.font = UIFont.boldSystemFont(ofSize: 16.0)
            label.text = "Trending Nearby"
            label.textColor = hexStringToUIColor("#333333")
            let button   = UIButton(type: UIButtonType.system) as UIButton
            button.addTarget(self, action: "visibleRow:", for:.touchUpInside)
            label.translatesAutoresizingMaskIntoConstraints = false
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle("Test Title", for: UIControlState())
            let views = ["label": label,"button":button,"view": view]
            view.addSubview(label)
            view.addSubview(button)
            let horizontallayoutContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[label]-60-[button]-10-|", options: .alignAllCenterY, metrics: nil, views: views)
            view.addConstraints(horizontallayoutContraints)
            
            let verticalLayoutContraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
            view.addConstraint(verticalLayoutContraint)
            self.tableView.tableHeaderView = view
            view.backgroundColor = hexStringToUIColor("#f5f5f5")

            return view
        }
        return nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GroupsTableViewCell
        
        var group = self.groups[(indexPath as NSIndexPath).section]
        cell.titleLabel.text = group[PF_GROUPS_NAME] as? String
        
        let timeline = group[PF_GROUPS_TIMELINE] as? Date
        let playerName = group[PF_GROUPS_POINTER] as! NSMutableArray
        let playerNameCount = String(playerName.count)
        
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
        
        let updatedDayFormatter = DateFormatter()
        updatedDayFormatter.dateFormat = "d"
        let updatedDay = updatedDayFormatter.string(from: morningOfChristmas)
        
        let updatedMonthFormatter = DateFormatter()
        updatedMonthFormatter.dateFormat = "MMM"
        let updatedMonth = updatedMonthFormatter.string(from: morningOfChristmas).uppercased()
        
        cell.dateLabel.text = updatedDay
        cell.monthLabel.text = updatedMonth
        
        var query = PFQuery(className: PF_CHAT_CLASS_NAME)
        query.whereKey(PF_CHAT_GROUPID, equalTo: group.objectId!)
        query.order(byDescending: PF_CHAT_CREATEDAT)
        query.limit = 1000
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if let chat = objects!.first {
                let date = Date()
                let seconds = date.timeIntervalSince(chat.createdAt!)
                let elapsed = Utilities.timeElapsed(seconds);
                let countString = (objects!.count > 1) ? "\(objects!.count) messages" : "\(objects!.count) message"
                cell.detailLabel.text = "\(countString) \(elapsed)"
            } else {
                cell.detailLabel.text = "0 messages"
            }
            cell.detailLabel.textColor = UIColor.lightGray
            if playerName.count == 1 {
                cell.subDetailLabel.text = "1 Person"
            }
            else {
            cell.subDetailLabel.text = "\(playerNameCount) People"
            }
        }
        
        // add border and color
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = hexStringToUIColor("#cccccc").cgColor
        border.frame = CGRect(x: 0, y: cell.layer.frame.size.height - width, width: cell.layer.frame.size.width, height: cell.layer.frame.size.height)
        
        border.borderWidth = width
        cell.layer.addSublayer(border)
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let group = self.groups[(indexPath as NSIndexPath).section]
        let groupId = group.objectId! as String
        
        Messages.createMessageItem(PFUser(), groupId: groupId, description: group[PF_GROUPS_NAME] as! String)
        
        self.performSegue(withIdentifier: "groupChatSegue", sender: groupId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "groupChatSegue" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            chatVC.groupId = groupId
        }
    }
}
