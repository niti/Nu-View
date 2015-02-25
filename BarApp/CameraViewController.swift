//
//  ViewController.swift
//  SwiftPizzaCam
//
//  Created by Steven Lipton on 12/3/14.
//  Copyright (c) 2014 Steven Lipton. All rights reserved.
//
// Basic a camera app that takes pictures and grabs them for a background from the photo library

import UIKit

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var myImageView: UIImageView!
    let picker = UIImagePickerController()   //our controller.
    //Memory will be conserved a bit if you place this in the actions.
    // I did this to make code a bit more streamlined
    
    //MARK: - Methods
    // An alert method using the new iOS 8 UIAlertController instead of the deprecated UIAlertview
    // make the alert with the preferredstyle .Alert, make necessary actions, and then add the actions.
    // add to the handler a closure if you want the action to do anything.
    
    func noCamera(){
        let alertVC = UIAlertController(title: "No Camera", message: "Sorry, this device has no camera", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style:.Default, handler: nil)
        alertVC.addAction(okAction)
        presentViewController(alertVC, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    //get a photo from the library. We present as a popover on iPad, and fullscreen on smaller devices.
    @IBAction func photoFromLibrary(sender: UIBarButtonItem) {
        picker.allowsEditing = false //2
        picker.sourceType = .PhotoLibrary //3
        picker.modalPresentationStyle = .Popover
        presentViewController(picker, animated: true, completion: nil)//4
        picker.popoverPresentationController?.barButtonItem = sender
    }
    
    //take a picture, check if we have a camera first.
    @IBAction func shootPhoto(sender: UIBarButtonItem) {
        if UIImagePickerController.availableCaptureModesForCameraDevice(.Rear) != nil {
            picker.allowsEditing = false
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.cameraCaptureMode = .Photo
            presentViewController(picker, animated: true, completion: nil)
        } else {
            noCamera()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        picker.delegate = self   //the required delegate to get a photo back to the app.
    }
    //MARK: - Delegates
    //What to do when the picker returns with a photo
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var chosenImage = info[UIImagePickerControllerOriginalImage] as UIImage //2
        myImageView.contentMode = .ScaleAspectFit //3
        myImageView.image = chosenImage //4
        dismissViewControllerAnimated(true, completion: nil) //5
    }
    //What to do if the image picker cancels.
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}




////
////  CameraViewController.swift
////  BarApp
////
////  Created by Allison Moyer on 2/19/15.
////  Copyright (c) 2015 Allison Moyer. All rights reserved.
////
//
//import UIKit
//import AVFoundation
//
//
//// Copied this code
//
//class CameraViewController: UIViewController {
//        
//        let captureSession = AVCaptureSession()
//        var previewLayer : AVCaptureVideoPreviewLayer?
//        
//        // If we find a device we'll store it here for later use
//        var captureDevice : AVCaptureDevice?
//        
//        override func viewDidLoad() {
//            super.viewDidLoad()
//            
//            // Do any additional setup after loading the view, typically from a nib.
//            captureSession.sessionPreset = AVCaptureSessionPresetHigh
//            
//            
//            let devices = AVCaptureDevice.devices()
//            
//            println(devices)
//            
//            // Loop through all the capture devices on this phone
//            for device in devices {
//                // Make sure this particular device supports video
//                if (device.hasMediaType(AVMediaTypeVideo)) {
//                    // Finally check the position and confirm we've got the back camera
//                    if(device.position == AVCaptureDevicePosition.Back) {
//                        captureDevice = device as? AVCaptureDevice
//                        if captureDevice != nil {
//                            println("Capture device found")
//                            beginSession()
//                        }
//                    }
//                }
//            }
//            
//        }
//        
//        func focusTo(value : Float) {
//            if let device = captureDevice {
//                if(device.lockForConfiguration(nil)) {
//                    device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
//                        //
//                    })
//                    device.unlockForConfiguration()
//                }
//            }
//        }
//        
//        let screenWidth = UIScreen.mainScreen().bounds.size.width
//        override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
//            var anyTouch = touches.anyObject() as UITouch
//            var touchPercent = anyTouch.locationInView(self.view).x / screenWidth
//            focusTo(Float(touchPercent))
//        }
//        
//        override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
//            var anyTouch = touches.anyObject() as UITouch
//            var touchPercent = anyTouch.locationInView(self.view).x / screenWidth
//            focusTo(Float(touchPercent))
//        }
//        
//        func configureDevice() {
//            if let device = captureDevice {
//                device.lockForConfiguration(nil)
//                device.focusMode = .Locked
//                device.unlockForConfiguration()
//            }
//            
//        }
//        
//        func beginSession() {
//            
//            configureDevice()
//            
//            var err : NSError? = nil
//            captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
//            
//            if err != nil {
//                println("error: \(err?.localizedDescription)")
//            }
//            
//            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
//            self.view.layer.addSublayer(previewLayer)
//            previewLayer?.frame = self.view.layer.frame
//            captureSession.startRunning()
//        }
//        
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
