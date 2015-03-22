//
//  LoginViewController.swift
//  BarApp
//
//  Created by Allison Moyer on 2/22/15.
//  Copyright (c) 2015 Allison Moyer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() != nil && // Check if user is cached
            PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()) { // Check if user is linked to Facebook
                // Present the next view controller without animation
                self.performSegueWithIdentifier("exitLogin", sender: self)
                
        }
        
    
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationController?.navigationBarHidden = true
        
        if PFUser.currentUser() != nil && // Check if user is cached
        PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()) { // Check if user is linked to Facebook
            // Present the next view controller without animation
            self.performSegueWithIdentifier("exitLogin", sender: self)
            //self.presentViewController(BarListTableViewController(), animated: false, completion: nil)
        }
        
        
    }
    
    
    @IBAction func loginPressed(sender: AnyObject) {
        
        var permissions = ["public_profile"]
        
        PFFacebookUtils.logInWithPermissions(permissions, {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                //println("Hey")
                NSLog(error.description)
            } else if user.isNew {
                self.performSegueWithIdentifier("exitLogin", sender: self)
                NSLog("User signed up and logged in through Facebook!")
                
            } else {
                self.performSegueWithIdentifier("exitLogin", sender: self)
                NSLog("User logged in through Facebook!")
                
            }
        })
        

        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
