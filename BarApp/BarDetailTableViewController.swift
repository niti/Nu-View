//
//  BarDetailTableViewController.swift
//  BarApp
//
//  Created by Allison Moyer on 2/18/15.
//  Copyright (c) 2015 Allison Moyer. All rights reserved.
//

import UIKit
import MobileCoreServices

class BarDetailTableViewController: PFQueryTableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var barDetailLogo: UIImageView!
    
    var bar: Bar?
    
    let picker = UIImagePickerController()
    
    //var imageViewsArray: [UIImageView] = []
    //var imageNamesArray: [String] = []
    var imageFiles: [PFFile] = []
    var usernames: [String] = []
    var profilePictures: [UIImage] = []
    var times: [String] = []
    
    var imageCache = [String : UIImage]()
    
    var refresher: UIRefreshControl!
    var activityIndicator: UIActivityIndicatorView!
    var progressView: UIProgressView!
    
    @IBAction func didDoubleTap(sender: AnyObject) {
    }
    
    // Initialise the PFQueryTable tableview
    override init!(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = bar?.title
        //self.textKey = "nameEnglish"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
    }
    
    
    // Define the query that will provide the data for the table view
    override func queryForTable() -> PFQuery! {
        var query = PFQuery(className: bar?.title)
        
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
        
        // If Pull To Refresh is enabled, query against the network by default.
//        if (self.pullToRefreshEnabled) {
//            //query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//            query.cachePolicy = kPFCachePolicyNetworkOnly;
//        }
        
        // If no objects are loaded in memory, we look to the cache first to fill the table
        // and then subsequently do a query against the network.
//        if (self.objects.count == 0) {
//            query.cachePolicy = kPFCachePolicyCacheThenNetwork;
//        } else {
//            query.cachePolicy = kPFCachePolicyCacheElseNetwork;
//        }
        
        println(self.objects.count)
        
        query.orderByDescending("createdAt")
        return query
    }
    
    
    //override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject) -> PFTableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("barDetailTableCell") as BarDetailTableViewCell!
        if cell == nil {
            cell = BarDetailTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "barDetailTableCell")
        }
        
        if (object.isDataAvailable()) {
        
            cell.object = object
            
            // Extract values from the PFObject to display in the table cell        
            var userQuery = PFUser.query()
            var userRef = object["user"] as PFObject
            userQuery.whereKey("objectId", equalTo: userRef.objectId)
            var user = userQuery.findObjects().first as PFUser
            
            cell.userName.text = user["name"] as? String
            cell.profilePicture.image = UIImage(data: user["image"] as NSData)!
            

    //        let imageView = PFImageView()
    //        imageView.image = UIImage(named: "image1.png") // placeholder image
    //        imageView.file = object["imageFile"] as PFFile // remote image
    //        
    //        cell.barDetailImageCell = imageView
    //
            
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            if !cell.liked {
                let recognizer = UITapGestureRecognizer(target: self, action: Selector("handleDoubleTap:"))
                recognizer.numberOfTapsRequired = 2
                cell.userInteractionEnabled = true
                cell.addGestureRecognizer(recognizer)
            }
            
            
            if let likes: NSNumber = object["likes"] as? NSNumber {
                cell.numOfLikes.text = likes.stringValue
            }
            
            var createdTime = object.createdAt as NSDate
            var currentTime = NSDate()

            let calendar = NSCalendar.currentCalendar()
            let createdComp = calendar.components((.HourCalendarUnit | .MinuteCalendarUnit), fromDate: createdTime)
            let createdHour = createdComp.hour
            let createdMinute = createdComp.minute
            let createdSecond = createdComp.second
            let currentComp = calendar.components((.HourCalendarUnit | .MinuteCalendarUnit), fromDate: currentTime)
            let currentHour = currentComp.hour
            let currentMinute = currentComp.minute
            let currentSecond = currentComp.second
            
            if (createdHour < currentHour){
                cell.timeSincePost.text = String(currentHour - createdHour) + "h"
            } else if (createdMinute < currentMinute) {
                cell.timeSincePost.text = String(currentMinute - createdMinute) + "m"
            } else {
                cell.timeSincePost.text = String(currentSecond - createdSecond) + "s"
            }
            
            var imageFile = object["imageFile"] as PFFile
            cell.barDetailImageCell.image = UIImage(named: "image1.png")
            var image = self.imageCache[imageFile.name]
            
            
            
    //        
    //        //cell.barDetailImageCell.file = object["imageFile"] as PFFile
    //        if image == nil {
    //            imageFile.getDataInBackgroundWithBlock {
    //                (imageData: NSData!, error: NSError!) -> Void in
    //                if error == nil {
    //                    cell.barDetailImageCell.image = UIImage(data: imageData)
    //                    self.imageCache[imageFile.name] = UIImage(data: imageData)
    //                }
    //            }
    //        }
    //        else {
    //            cell.barDetailImageCell.image = image
    //        }
            
            
            
            if (image == nil) {
                cell.barDetailImageCell.file = imageFile
                if (cell.barDetailImageCell.file.isDataAvailable) {
                    cell.barDetailImageCell.loadInBackground({ (image, error) -> Void in
                        self.imageCache[imageFile.name] = image
                    })
                }
            } else {
                cell.barDetailImageCell.image = image
            }
        
        }
        
        return cell
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if (recognizer.view != nil) {
            let image = recognizer.view as BarDetailTableViewCell
            var numLikes: Int
            
            if image.liked {
                image.removeGestureRecognizer(recognizer)
                return
            }
            
            if (image.numOfLikes.text?.toInt() == nil) {
                numLikes = 0
            } else {
                numLikes = (image.numOfLikes.text?.toInt())!
            }
            
            image.numOfLikes.text = String(numLikes + 1)
            
            var object = image.object
            
            object["likes"] = (numLikes + 1)
            object.saveInBackgroundWithBlock { (success, error) -> Void in
                if (success) {
                    println(numLikes+1)
                    image.liked = true
                }
            }
            
        }
        
    }
    
    
    override func objectsWillLoad() {
        super.objectsWillLoad()
    
    // This method is called before a PFQuery is fired to get more objects
    }
    
    override func objectsDidLoad (error: NSError) {
        super.objectsDidLoad(error)
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        if bar != nil {
            barDetailLogo.image = bar!.icon
            //imageNamesArray = bar!.imageNamesArray
        }
        
//        updatePictures()
//        
//        
//        
//        refresher = UIRefreshControl()
//        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//        self.tableView.addSubview(refresher)
//        
        activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.center = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2)
        
        //activityIndicator.ce
        self.tableView.addSubview(activityIndicator)
//
//        progressView = UIProgressView()
//        self.tableView.addSubview(progressView)
        
        
        //imageNamesArray = ["image0.png", "image1.png", "image2.png", "image3.png", "image4.png"]
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func updatePictures() {
        
        self.imageFiles.removeAll(keepCapacity: true)
        
        var query = PFQuery(className: bar?.title)
        var count = query.countObjects()
        
        
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                
                // Do something with the found objects
                for object in objects {
                    
                    self.imageFiles.append(object["imageFile"] as PFFile)
                    
                    
                    var userQuery = PFUser.query()
                    var userRef = object["user"] as PFObject
                    userQuery.whereKey("objectId", equalTo: userRef.objectId)
                    var user = userQuery.findObjects().first as PFUser
                    
                    self.usernames.append(user["name"] as String)
                    self.profilePictures.append(UIImage(data: user["image"] as NSData)!)
                    
                                        
                }
                
                self.tableView.reloadData()
                
            } else {
                // Log details of the failure
                println("error")
                //NSLog("Error: %@ %@", error, error.userInfo!)
            }
            self.refresher.endRefreshing()
        }
        
    }
    
    func refresh() {
        
//        updatePictures()
//        println("refreshed")
        
        
    }
    
    
    override func viewWillAppear(animated: Bool){
        //updatePictures()
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = UIColor(white: 0, alpha: 1)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navbar.png"), forBarMetrics: .Default)
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

//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return imageFiles.count
//    }
//
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> BarDetailTableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("barDetailTableCell", forIndexPath: indexPath) as BarDetailTableViewCell
//        
//        cell.backgroundColor = UIColor.clearColor()
//        
//        cell.userName.text = usernames[indexPath.row]
//        cell.profilePicture.image = profilePictures[indexPath.row]
//        
//        var image = self.imageCache[imageFiles[indexPath.row].name]
//        
//        if image == nil {
//            imageFiles[indexPath.row].getDataInBackgroundWithBlock {
//                (imageData: NSData!, error: NSError!) -> Void in
//                
//                if error == nil {
//                    cell.barDetailImageCell.image = UIImage(data: imageData)
//                    self.imageCache[self.imageFiles[indexPath.row].name] = UIImage(data: imageData)
//                    
//                }
//            }
//        }
//        
//        if image != nil {
//            cell.barDetailImageCell.image = image
//        }
//
//        
//        return cell
//    }
    
    
    
    
    override func tableView(tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 350;
    }
    
    
    
    
    
    
    //Camera
    
    @IBAction func shootPhoto(sender: UIBarButtonItem) {
        var newCell = PFTableViewCell()
        self.view.addSubview(newCell)
        activityIndicator.startAnimating()
        
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = true
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            presentViewController(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - Delegates
    //What to do when the picker returns with a photo
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
            println("Picker returned successfully")
            
            let mediaType:AnyObject? = info[UIImagePickerControllerMediaType]
            
            if let type:AnyObject = mediaType{
                
                if type is String{
                    let stringType = type as String
                    
                    if stringType == kUTTypeImage as NSString{
                        
                        var theImage: UIImage!
                        
                        if picker.allowsEditing{
                            theImage = info[UIImagePickerControllerEditedImage] as UIImage
                        } else {
                            theImage = info[UIImagePickerControllerOriginalImage] as UIImage
                        }
                        
                        
                        let selectorAsString =
                        "imageWasSavedSuccessfully:didFinishSavingWithError:context:"
                        
                        let selectorToCall = Selector(selectorAsString)
                        
                        let imageData = UIImagePNGRepresentation(theImage)
                        let imageFile: PFFile = PFFile(data: imageData)
                        
                        
                        var userPhoto = PFObject(className: bar?.title)
                        userPhoto["imageFile"] = imageFile
                        userPhoto["likes"] = 0
                        userPhoto["user"] = PFUser.currentUser()
                        self.activityIndicator.startAnimating()
                        userPhoto.saveInBackgroundWithBlock ({
                            (succeeded: Bool!, error: NSError!) -> Void in
                            // Handle success or failure here ...
                            if succeeded == true {
                                self.activityIndicator.stopAnimating()
                                self.loadObjects()
                            }
                        })
                        
//                        userPhoto.saveInBackgroundWithBlock({{ (succeeded: Bool, error: NSError!) -> Void in
//                            
//                            // Check there was no error, begin handling the file upload
//                            // trimmed out un-necessary code
//                            
//                            if succeeded == true {
//                                //progressView.
//                            }
//                            
//                            
//                            }
//                            progressBlock: { (amountDone: Int32) -> Void in
//                                self.progressView.setProgress(amountDone as Float, animated: true)
//                            }})
                        
                        
                        
                        
//                        UIImageWriteToSavedPhotosAlbum(theImage,
//                            self,
//                            selectorToCall,
//                            nil)
                        
                        
                        
                    }
                    
                }
            }
            
            picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: {
            self.loadObjects()
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "showCamera" {
            
                let pictureViewController = segue.destinationViewController as PictureViewController
                pictureViewController.bar = bar
                            
            }
        
        
        
    }
    

}
