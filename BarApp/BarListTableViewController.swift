
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
    //var user: PFObject?
    
    @IBAction func logoutButtonPressed(sender: AnyObject) {        
        PFUser.logOut()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if PFUser.currentUser()["name"] == nil {
           self.loadData() 
        }
        
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

    }
    
    override func viewWillAppear(animated: Bool){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor(white: 0, alpha: 1)
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navbar.png"), forBarMetrics: .Default)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "splash.png")!)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
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
        
        cell.backgroundColor = UIColor.clearColor()
        //cell.
        
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
            return 75;
    }
    
    
    func loadData() {
        
        println("Getting Data")
        
        var user = PFUser.currentUser()
        var FBSession = PFFacebookUtils.session()
        var accessToken = FBSession.accessTokenData.accessToken
        let url = NSURL(string: "https://graph.facebook.com/me/picture?type=large&return_ssl_resources=1&access_token="+accessToken)
        
        // Update - changed url to url!
        
        let urlRequest = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            response, data, error in
            
            //println(data)
            
            if data != nil {
                user["image"] = data
            }
            
            user.save()
            
            FBRequestConnection.startForMeWithCompletionHandler({
                connection, result, error in
                
                //println(result["name"])
                
                if result != nil {
                    user["name"] = result["name"]
                }
                
                //println(user["name"])
                
                //self.nameLabel.text = user["name"] as? String
                
                user.save()
                //println(result)
                
                
            })
            
        })
        
        
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
