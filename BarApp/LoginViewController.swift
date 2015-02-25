//
//  LoginViewController.swift
//  BarApp
//
//  Created by Allison Moyer on 2/22/15.
//  Copyright (c) 2015 Allison Moyer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //var user = PFUser.currentUser()
        
        if PFUser.currentUser() != nil && // Check if user is cached
            PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()) { // Check if user is linked to Facebook
                // Present the next view controller without animation
                self.performSegueWithIdentifier("exitLogin", sender: self)
                //self.presentViewController(BarListTableViewController(), animated: false, completion: nil)
                
        }
        
        else {
            //loginButtonView.image = UIImage(named: "facebooklogin.png")
        }
        
//        
//        var loginView = FBLoginView()
//        loginView.center = self.view.center
//        loginView.delegate = self
//        self.view.addSubview(loginView)
        
        //NOTE
//        If you define the login UI in Interface Builder:
//        
//        Select the View that represents the login button.
//        In the Connections Inspector, connect the delegate outlet to the File's Owner.
    
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
                println("Hey")
                //NSLog(error.fberrorUserMessage)
                //NSLog(error.description)
            } else if user.isNew {
                self.performSegueWithIdentifier("exitLogin", sender: self)
                NSLog("User signed up and logged in through Facebook!")
            
                
                
                //self.dismissViewControllerAnimated(true, completion: nil)
            } else {
                self.performSegueWithIdentifier("exitLogin", sender: self)
                NSLog("User logged in through Facebook!")
                
            }
        })
        

        
    }
    

    
    
    
    
    
    
//    // Call method when user information has been fetched
//    func loginViewFetchedUserInfo(loginView: FBLoginView, user: FBGraphUser) {
//        
//        self.profilePictureView.profileID = user.objectID;
//        self.nameLabel.text = user.name;
//        
//        var userApp = PFUser.currentUser()
//        
//        if userApp == nil {
//            //println(PFUser.currentUser().objectId)
//            //dismissViewControllerAnimated(true, completion: nil)
//            
//            userApp = PFUser()
//            
//            userApp.objectId = user.objectID
//            userApp.username = user.username
//            userApp["name"] = user.name
//            
//            userApp.save()
//            
//        }
//        else {
//            println(userApp.objectId)
//        }
//        
//
//    
//    }
//    
    
    @IBAction func dismissView(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
//    
//    // Handle possible errors that can occur during login
//    func loginView(loginView: FBLoginView, error: NSError) {
//    
//        var alertMessage: NSString?
//        var alertTitle: NSString?
//    
//        // If the user performs an action outside of you app to recover,
//        // the SDK provides a message, you just need to surface it.
//        // This handles cases like Facebook password change or unverified Facebook accounts.
//        if (FBErrorUtility.shouldNotifyUserForError(error)) {
//            alertTitle = "Facebook error"
//            alertMessage = FBErrorUtility.userMessageForError(error)
//            
//        // This code will handle session closures that happen outside of the app
//        // You can take a look at our error handling guide to know more about it
//        // https://developers.facebook.com/docs/ios/errors
//        } else if (FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.AuthenticationReopenSession) {
//            alertTitle = "Session Error"
//            alertMessage = "Your current session is no longer valid. Please log in again."
//            
//        // If the user has cancelled a login, we will do nothing.
//        // You can also choose to show the user a message if cancelling login will result in
//        // the user not being able to complete a task they had initiated in your app
//        // (like accessing FB-stored information or posting to Facebook)
//        } else if (FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.UserCancelled) {
//            NSLog("user cancelled login");
//        
//        // For simplicity, this sample handles other errors with a generic message
//        // You can checkout our error handling guide for more detailed information
//        // https://developers.facebook.com/docs/ios/errors
//        } else {
//            alertTitle  = "Something went wrong";
//            alertMessage = "Please try again later.";
//            NSLog("Unexpected error:%@", error);
//        }
//        
//        if ((alertMessage) != nil) {
//            
//            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
//            let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
//            alert.addAction(okAction)
//            presentViewController(alert, animated: true, completion: nil)
//
//        }
//    }
    
    

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
