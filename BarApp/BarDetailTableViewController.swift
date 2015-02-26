//
//  BarDetailTableViewController.swift
//  BarApp
//
//  Created by Allison Moyer on 2/18/15.
//  Copyright (c) 2015 Allison Moyer. All rights reserved.
//

import UIKit
import MobileCoreServices

class BarDetailTableViewController: UITableViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var barDetailLogo: UIImageView!
    
    var bar: Bar?
    
    let picker = UIImagePickerController()
    
    //var imageViewsArray: [UIImageView] = []
    //var imageNamesArray: [String] = []
    var imageFiles: [PFFile] = []
    var usernames: [String] = []
    var profilePictures: [UIImage] = []
    
    var refresher: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        if bar != nil {
            barDetailLogo.image = bar!.icon
            //imageNamesArray = bar!.imageNamesArray
        }
        
        updatePictures()
        
        
        
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refresher)
        
        
        //imageNamesArray = ["image0.png", "image1.png", "image2.png", "image3.png", "image4.png"]
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func updatePictures() {
        
        
        var query = PFQuery(className: bar?.title)
        var count = query.countObjects()
        
        
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find succeeded.
                
                // Do something with the found objects
                for object in objects {
                    //if (imageNamesArray.)
                    
                    //self.usernames.append(object["user"])
                    //println(object.objectId)
                    
                    if (!(contains(self.imageFiles, object["imageFile"] as PFFile))) {
                        self.imageFiles.append(object["imageFile"] as PFFile)
                    }
                    
                    //var user = object.objectForKey("user") as PFUser
                    var user = PFUser()
                    var userQuery = PFUser.query()
                    var userRef = object["user"] as PFObject
                    var id = userRef.objectId
                    println(id)
                    userQuery.whereKey("objectId", equalTo: id)
                    var users = userQuery.findObjects()
                    
                    //userQuery.wh
                    
                    user = users.first as PFUser
                    
                    println(user["name"])
                    
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
        
        //updatePictures()
        println("refreshed")
        
        
    }
    
    
    override func viewWillAppear(animated: Bool){
        //updatePictures()
        self.navigationController?.navigationBarHidden = false
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
        return imageFiles.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> BarDetailTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("barDetailTableCell", forIndexPath: indexPath) as BarDetailTableViewCell
        
        cell.userName.text = usernames[indexPath.row]
        cell.profilePicture.image = profilePictures[indexPath.row]
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock {
            (imageData: NSData!, error: NSError!) -> Void in
            
            if error == nil {
                let image = UIImage(data: imageData)
                //println(image)
                cell.loadImage(image!, bar: self.bar!)
            }
            
            self.refresher.endRefreshing()
            
            
        }
        
        //cell.loadImage(imageNamesArray[indexPath.row], bar: bar!)
        
        return cell
    }
    
    override func tableView(tableView: UITableView,
        estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            return 310;
    }
    
    
    
    
    
    
    //Camera
    
    @IBAction func shootPhoto(sender: UIBarButtonItem) {
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
                        userPhoto["user"] = PFUser.currentUser()
                        userPhoto.save()
                        
                        
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
        picker.dismissViewControllerAnimated(true, completion: nil)
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
