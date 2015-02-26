//
//  BarDetailTableViewCell.swift
//  BarApp
//
//  Created by Allison Moyer on 2/18/15.
//  Copyright (c) 2015 Allison Moyer. All rights reserved.
//

import UIKit

class BarDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var barDetailImageCell: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func loadImage(image:String) {
        
        var query = PFQuery(className: "BarPictures")
        query.whereKey("objectId", equalTo:image)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                println("Successfully retrieved \(objects.count) records.")
                for object in objects {
                    let userImageFile = object["imageFile"] as PFFile!
                    userImageFile.getDataInBackgroundWithBlock {
                        (imageData: NSData!, error: NSError!) -> Void in
                        if error == nil {
                            self.barDetailImageCell.image = UIImage(data:imageData)!
                            println("Image successfully retrieved")
                        }
                    }
                }
                
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
        
        
    }
    
    
//    func loadImage(image: String) {
//        var barImageFile =
//        var barImage  = PFQuery(className: "BarPictures")
//        barImage.whereKey("objectId", equalTo:image)
//        barImage.limit = 1;
//        
//        barImage.getDataInBackgroundWithBlock{
//            
//        }
//        
//        barDetailImageCell.image = UIImage(named: image)
//    }

}
