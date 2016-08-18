//
//  ObjectsTableViewController.swift
//  PFQueryTableViewController Xcode 7
//
//  Created by PJ Vea on 11/9/15.
//  Copyright © 2015 Vea Software. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class RestaurantTableViewController: PFQueryTableViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func queryForTable() -> PFQuery
    {
        let query = PFQuery(className: "_User")
        query.cachePolicy = .CacheElseNetwork
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell?
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! RestaurantTableViewCell
        
        cell.nameLabel?.text = object?.objectForKey("FirstName") as? String
        cell.locationLabel?.text = object?.objectForKey("Location") as? String
        cell.typeLabel?.text = object?.objectForKey("Type") as? String
        
        let imageFile = object?.objectForKey("UserImage") as? PFFile
        cell.thumbnailImageView?.image = UIImage(named: "placeholder")
        cell.thumbnailImageView?.file = imageFile
        cell.thumbnailImageView.loadInBackground()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if indexPath.row + 1 > self.objects?.count
        {
            return 44
        }
        let height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        return height
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if indexPath.row + 1 > self.objects?.count
        {
            self.loadNextPage()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        else
        {
            self.performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "showDetail"
        {
            let indexPath = self.tableView.indexPathForSelectedRow
            let nav = segue.destinationViewController as! UINavigationController
            let detailVC = nav.topViewController as! RestaurantDetailTableViewController
            let object = self.objectAtIndexPath(indexPath)
            detailVC.nameData = object?.objectForKey("Name") as! String
            detailVC.image = object?.objectForKey("Image") as! PFFile
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
    }
    
}
