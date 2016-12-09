//
//  MessagesViewController.swift
//  VayK
//
//  Created by Hayne Park on 11/28/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit
import Parse

class MessagesViewController: UITableViewController, UIActionSheetDelegate, SelectSingleViewControllerDelegate, SearchTableViewControllerDelegate {
    
    var messages = [PFObject]()
    // UITableViewController already declares refreshControl
    
    @IBOutlet var composeButton: UIBarButtonItem!
    @IBOutlet var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.cleanup), name: NSNotification.Name(rawValue: NOTIFICATION_USER_LOGGED_OUT), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.loadMessages), name: NSNotification.Name(rawValue: "reloadMessages"), object: nil)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(MessagesViewController.loadMessages), for: UIControlEvents.valueChanged)
        self.tableView?.addSubview(self.refreshControl!)
        
        self.emptyView?.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if PFUser.current() != nil {
            self.loadMessages()
        } else {
            Utilities.loginUser(self)
        }
    }
    
    // MARK: - Backend methods
    
    func loadMessages() {
        let query = PFQuery(className: PF_MESSAGES_CLASS_NAME)
        query.whereKey(PF_MESSAGES_USER, equalTo: PFUser.current()!)
        query.includeKey(PF_MESSAGES_LASTUSER)
        query.order(byDescending: PF_MESSAGES_UPDATEDACTION)
        query.findObjectsInBackground { (objects: [PFObject]?, error: Error?) -> Void in
            if error == nil {
                self.messages.removeAll(keepingCapacity: false)
                self.messages += objects as! [PFObject]!
                self.tableView.reloadData()
                self.updateEmptyView()
                self.updateTabCounter()
            } else {
                ProgressHUD.showError("Network error")
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: - Helper methods
    
    func updateEmptyView() {
        self.emptyView?.isHidden = (self.messages.count != 0)
    }
    
    func updateTabCounter() {
        var total = 0
        for message in self.messages {
            total += (message[PF_MESSAGES_COUNTER] as AnyObject).intValue
        }
        var item = self.tabBarController?.tabBar.items?[2] as UITabBarItem?
        //item!.badgeValue = (total == 0) ? nil : "\(total)"
    }
    
    // MARK: - User actions
    
    func openChat(_ groupId: String) {
        self.performSegue(withIdentifier: "messagesChatSegue", sender: groupId)
    }
    
    func cleanup() {
        self.messages.removeAll(keepingCapacity: false)
        self.tableView.reloadData()
        
        let item = self.tabBarController?.tabBar.items?[1] as UITabBarItem?
        item!.badgeValue = nil
    }
    
    @IBAction func compose(_ sender: UIBarButtonItem) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Single recipient", "Multiple recipients", "Address Book", "Facebook Friends")
        actionSheet.show(from: self.tabBarController!.tabBar)
    }

    // MARK: - Prepare for segue to chatVC

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messagesChatSegue" {
            let chatVC = segue.destination as! ChatViewController
            chatVC.hidesBottomBarWhenPushed = true
            let groupId = sender as! String
            chatVC.groupId = groupId
        } else if segue.identifier == "selectSingleSegue" {
            let selectSingleVC = (segue.destination as! UINavigationController).topViewController as! SelectSingleViewController
            //let selectSingleVC = segue.destinationViewController.topViewController as! SelectSingleViewController
            selectSingleVC.delegate = self
        } else if segue.identifier == "selectSingleSegue" {
            let selectSingleVC = (segue.destination as! UINavigationController).topViewController as! SearchTableViewController
            //let selectSingleVC = segue.destinationViewController.topViewController as! SelectSingleViewController
            selectSingleVC.delegate = self
        }
    }

    // MARK: - UIActionSheetDelegate
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex != actionSheet.cancelButtonIndex {
            switch buttonIndex {
            case 1:
                self.performSegue(withIdentifier: "selectSingleSegue", sender: self)
            case 2:
                self.performSegue(withIdentifier: "selectMultipleSegue", sender: self)
            case 3:
                self.performSegue(withIdentifier: "addressBookSegue", sender: self)
            case 4:
                self.performSegue(withIdentifier: "facebookFriendsSegue", sender: self)
            default:
                return
            }
        }
    }
    
    // MARK: - SearchDelegate
    
    func didSearchUser(_ user2: PFUser) {
        let user1 = PFUser.current()
        let groupId = Messages.startPrivateChat(user1!, user2: user2)
        self.openChat(groupId)
    }
    
    // MARK: - SelectSingleDelegate
    
    func didSelectSingleUser(_ user2: PFUser) {
        let user1 = PFUser.current()
        let groupId = Messages.startPrivateChat(user1!, user2: user2)
        self.openChat(groupId)
    }
    
    // MARK: - SelectMultipleDelegate
    
    func didSelectMultipleUsers(_ selectedUsers: [PFUser]!) {
        let groupId = Messages.startMultipleChat(selectedUsers)
        self.openChat(groupId)
    }
    
    // MARK: - AddressBookDelegate
    
    func didSelectAddressBookUser(_ user2: PFUser) {
        let user1 = PFUser.current()
        let groupId = Messages.startPrivateChat(user1!, user2: user2)
        self.openChat(groupId)
    }
    
    // MARK: - FacebookFriendsDelegate
    
    func didSelectFacebookUser(_ user2: PFUser) {
        let user1 = PFUser.current()
        let groupId = Messages.startPrivateChat(user1!, user2: user2)
        self.openChat(groupId)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messagesCell") as! MessagesCell
        cell.bindData(self.messages[(indexPath as NSIndexPath).row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        Messages.deleteMessageItem(self.messages[(indexPath as NSIndexPath).row])
        self.messages.remove(at: (indexPath as NSIndexPath).row)
        self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
        self.updateEmptyView()
        self.updateTabCounter()
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let message = self.messages[(indexPath as NSIndexPath).row] as PFObject
        self.openChat(message[PF_MESSAGES_GROUPID] as! String)
    }

}
