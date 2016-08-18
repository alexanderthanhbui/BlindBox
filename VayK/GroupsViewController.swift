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
    
    var groups: [PFObject]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "cleanup", name: NOTIFICATION_USER_LOGGED_OUT, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadGroups", name: "reloadMessages", object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "loadGroups", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView?.addSubview(self.refreshControl!)
        
        self.emptyView?.hidden = true
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if PFUser.currentUser() != nil {
            self.loadGroups()
        }
        else {
            Utilities.loginUser(self)
        }
    }
    
    // MARK: - Helper methods
    
    func updateEmptyView() {
        self.emptyView?.hidden = (self.groups.count != 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadGroups() {
        let query = PFQuery(className: PF_GROUPS_CLASS_NAME)
        query.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.groups.removeAll()
                self.groups.appendContentsOf(objects as [PFObject]!)
                self.tableView.reloadData()
                self.updateEmptyView()
            } else {
                ProgressHUD.showError("Network error")
                print(error)
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction func newButtonPressed(sender: UIBarButtonItem) {
        self.actionNew()
    }
    
    func actionNew() {
        let alert = UIAlertView(title: "Please enter a name for your group", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alert.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex != alertView.cancelButtonIndex {
            let textField = alertView.textFieldAtIndex(0);
            if let text = textField!.text {
                if text.characters.count > 0 {
                    let object = PFObject(className: PF_GROUPS_CLASS_NAME)
                    object[PF_GROUPS_NAME] = text
                    object.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
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
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 100
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groups.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! GroupsTableViewCell
        
        var group = self.groups[indexPath.row]
        cell.lol?.text = group[PF_GROUPS_NAME] as? String
        
        var query = PFQuery(className: PF_CHAT_CLASS_NAME)
        query.whereKey(PF_CHAT_GROUPID, equalTo: group.objectId!)
        query.orderByDescending(PF_CHAT_CREATEDAT)
        query.limit = 1000
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if let chat = objects!.first {
                let date = NSDate()
                let seconds = date.timeIntervalSinceDate(chat.createdAt!)
                let elapsed = Utilities.timeElapsed(seconds);
                let countString = (objects!.count > 1) ? "\(objects!.count) messages" : "\(objects!.count) message"
                cell.lp?.text = "\(countString) \(elapsed)"
            } else {
                cell.lp?.text = "0 messages"
            }
            cell.lp?.textColor = UIColor.lightGrayColor()
        }
        
        return cell
    }
    
    // MARK: - TableView Delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let group = self.groups[indexPath.row]
        let groupId = group.objectId! as String
        
        Messages.createMessageItem(PFUser(), groupId: groupId, description: group[PF_GROUPS_NAME] as! String)
        
        self.performSegueWithIdentifier("groupChatSegue", sender: groupId)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "groupChatSegue" {
            let chatVC = segue.destinationViewController as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            chatVC.groupId = groupId
        }
    }
}
