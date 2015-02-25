//
//  PictureViewController.swift
//  BarApp
//
//  Created by Niti Paudyal on 2/22/15.
//  Copyright (c) 2015 Allison Moyer. All rights reserved.
//

//copied code from O'Rilley

import UIKit
import MobileCoreServices

class PictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var beenHereBefore = false
    var controller: UIImagePickerController?
    
    func imageWasSavedSuccessfully(image: UIImage,
        didFinishSavingWithError error: NSError!,
        context: UnsafeMutablePointer<()>){
            
            if let theError = error{
                println("Error happened while saving the image = \(theError)")
            } else {
                println("Image was saved successfully")
            }
    }
    
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
                        
                        
                        var userPhoto = PFObject(className: "BarPictures")
                        userPhoto["imageFile"] = imageFile
                        userPhoto.saveInBackground()
            
                        
                        UIImageWriteToSavedPhotosAlbum(theImage,
                            self,
                            selectorToCall,
                            nil)
                        
                        var object = PFObject(className: "testDataClass")
                        object.addObject("iOSBlog", forKey: "websiteUrl")
                        object.addObject("Five", forKey: "websiteRating")
                        object.save()
                        
                    }
                    
                }
            }
            
            picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        
        println("Cancelled the Picker")
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func isCameraAvailable() -> Bool{
        return UIImagePickerController.isSourceTypeAvailable(.Camera)
    }
    
    func cameraSupportsMedia(mediaType: String,
        sourceType: UIImagePickerControllerSourceType) -> Bool{
            
            let availableMediaTypes =
            UIImagePickerController.availableMediaTypesForSourceType(sourceType) as
                [String]?
            
            if let types = availableMediaTypes{
                for type in types{
                    if type == mediaType{
                        return true
                    }
                }
            }
            
            return false
    }
    
    func doesCameraSupportTakingPhotos() -> Bool{
        return cameraSupportsMedia(kUTTypeImage as NSString, sourceType: .Camera)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if beenHereBefore{
            return
        } else {
            beenHereBefore = true
        }
        
        if isCameraAvailable() && doesCameraSupportTakingPhotos(){
            
            controller = UIImagePickerController()
            
            if let theController = controller{
                theController.sourceType = .Camera
                
                theController.mediaTypes = [kUTTypeImage as NSString]
                
                theController.allowsEditing = true
                theController.delegate = self
                
                presentViewController(theController, animated: true, completion: nil)
            }
            
        } else {
            println("Camera is not available")
        }
        
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



