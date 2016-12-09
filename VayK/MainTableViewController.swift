//
//  GroupViewController.swift
//  VayK
//
//  Created by Hayne Park on 11/28/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit
// Parse loaded from SwiftParseChat-Bridging-Header.h

class MainTableViewController: UITableViewController, UIAlertViewDelegate {
    
    @IBOutlet var emptyView: UIView!
    
    var groups: [PFObject]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: "cleanup", name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGGED_OUT), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainTableViewController.loadGroups), name: NSNotification.Name(rawValue: "reloadMessages"), object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(MainTableViewController.loadGroups), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(self.refreshControl!)
        
        self.emptyView?.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    // MARK: - TableView Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! GroupsTableViewCell
        
        var group = self.groups[(indexPath as NSIndexPath).row]
        cell.titleLabel.text = group[PF_GROUPS_NAME] as? String
        
        let timeline = group[PF_GROUPS_TIMELINE] as? Int
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        let year = yearFormatter.string(from: (group.createdAt as Date?)!)
        //dateString now contains the string ex."1987".
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MM"
        let month = monthFormatter.string(from: (group.createdAt as Date?)!)
        //dateString now contains the string "Aug".
        
        let dayOfWeekFormatter = DateFormatter()
        dayOfWeekFormatter.dateFormat = "eee"
        let dayOfWeek = dayOfWeekFormatter.string(from: (group.createdAt as Date?)!)
        //dateString now contains the string ex."Fri".
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "d"
        let day = dayFormatter.string(from: (group.createdAt as Date?)!)
        //dateString now contains the string ex."7".
        
        let hourFormatter = DateFormatter()
        hourFormatter.dateFormat = "H"
        let hour = hourFormatter.string(from: (group.createdAt as Date?)!)
        //dateString now contains the string ex."8".
        
        let minuteFormatter = DateFormatter()
        minuteFormatter.dateFormat = "mm"
        let minute = minuteFormatter.string(from: (group.createdAt as Date?)!)
        //dateString now contains the string ex."7".
        
        let secondFormatter = DateFormatter()
        secondFormatter.dateFormat = "sss"
        let second = secondFormatter.string(from: (group.createdAt as Date?)!)
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
        morningOfChristmasComponents.day = dateInt! + timeline!
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
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let group = self.groups[(indexPath as NSIndexPath).row]
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
