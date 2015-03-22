//
//  BarDetailTableViewCell.swift
//  BarApp
//
//  Created by Allison Moyer on 2/18/15.
//  Copyright (c) 2015 Allison Moyer. All rights reserved.
//

import UIKit

class BarDetailTableViewCell: PFTableViewCell {

    @IBOutlet weak var numOfLikes: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var timeSincePost: UILabel!
    @IBOutlet weak var barDetailImageCell: PFImageView!
    
    var object: PFObject!
    var liked: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadImage(image: UIImage, bar: Bar) {

        
        
        // User data
//        if PFUser.currentUser() != nil {
//            let user = PFUser.currentUser()
//            //println(user["imageData"])
//            
//            if let data: NSData = user["image"] as? NSData {
//                profilePicture.image = UIImage(data: data)
//            }
//            userName.text = user["name"] as? String
//        }
//        
//        else {
//            println("No User")
//        }
        
        
        // Pictures data
        
        self.barDetailImageCell.image = image
        
//        var query = PFQuery(className: bar.title)
//        query.whereKey("objectId", equalTo:image)
//        
//        query.findObjectsInBackgroundWithBlock {
//            (objects: [AnyObject]!, error: NSError!) -> Void in
//            if error == nil {
//                println("Successfully retrieved \(objects.count) records.")
//                for object in objects {
//                    let userImageFile = object["imageFile"] as PFFile!
//                    userImageFile.getDataInBackgroundWithBlock {
//                        (imageData: NSData!, error: NSError!) -> Void in
//                        if error == nil {
//                            self.barDetailImageCell.image = UIImage(data:imageData)!
//                            println("Image successfully retrieved")
//                        }
//                    }
//                }
//                
//            } else {
//                NSLog("Error: %@ %@", error, error.userInfo!)
//            }
//        }
        
        
    }

}
