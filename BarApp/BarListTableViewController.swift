
//
//  BarListTableViewController.swift
//  BarApp
//
//  Created by Allison Moyer on 2/21/15.
//  Copyright (c) 2015 Allison Moyer. All rights reserved.
//

import UIKit

class BarListTableViewController: UITableViewController {
    
    var imageNamesArray: [String] = []
    var imagesArray: [UIImage] = []
    var barImageViewsArray: [UIImageView] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barsLibrary = BarLibrary().library
        for dictionary in barsLibrary {
            imageNamesArray += [dictionary["icon"] as String!]
        }
        
        
        for file in imageNamesArray {
            var image = UIImage(named: file)
            imagesArray.append(image!)
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return imagesArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> BarListTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("barListTableCell", forIndexPath: indexPath) as BarListTableViewCell
        
        
        cell.loadImage(imagesArray[indexPath.row])
        
        let recognizer = UITapGestureRecognizer(target: self, action: Selector("handleTap:"))
        cell.userInteractionEnabled = true
        cell.addGestureRecognizer(recognizer)
        
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showBarDetail" {
            
            let listContentView = sender!.view as BarListTableViewCell
            
            if let index = find(imagesArray, listContentView.barImageView.image!) {
                
                let barDetailTableViewController = segue.destinationViewController as BarDetailTableViewController
                barDetailTableViewController.bar = Bar(index: index)
                
            }
            
        }
    }
    
    func handleTap(recognizer: UITapGestureRecognizer) {
        
        performSegueWithIdentifier("showBarDetail", sender: recognizer)
        
        
        
    }
    
    
    override func tableView(tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 88;
    }
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
