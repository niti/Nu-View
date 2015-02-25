//
//  CameraViewController.swift
//  BarApp
//
//  Created by Allison Moyer on 2/19/15.
//  Copyright (c) 2015 Allison Moyer. All rights reserved.
//

import UIKit
import AVFoundation


// Copied this code

class CameraViewController: UIViewController {
        
        let captureSession = AVCaptureSession()
        var previewLayer : AVCaptureVideoPreviewLayer?
        
        // If we find a device we'll store it here for later use
        var captureDevice : AVCaptureDevice?
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            // Do any additional setup after loading the view, typically from a nib.
            captureSession.sessionPreset = AVCaptureSessionPresetHigh
            
            let devices = AVCaptureDevice.devices()
            
            // Loop through all the capture devices on this phone
            for device in devices {
                // Make sure this particular device supports video
                if (device.hasMediaType(AVMediaTypeVideo)) {
                    // Finally check the position and confirm we've got the back camera
                    if(device.position == AVCaptureDevicePosition.Back) {
                        captureDevice = device as? AVCaptureDevice
                        if captureDevice != nil {
                            println("Capture device found")
                            beginSession()
                        }
                    }
                }
            }
        }
        
        func focusTo(value : Float) {
            if let device = captureDevice {
                if(device.lockForConfiguration(nil)) {
                    device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
                    })
                    device.unlockForConfiguration()
                }
            }
        }
        
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
            var anyTouch = touches.anyObject() as UITouch
            var touchPercent = anyTouch.locationInView(self.view).x / screenWidth
            focusTo(Float(touchPercent))
        }
        
        override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
            var anyTouch = touches.anyObject() as UITouch
            var touchPercent = anyTouch.locationInView(self.view).x / screenWidth
            focusTo(Float(touchPercent))
        }
        
        func configureDevice() {
            if let device = captureDevice {
                device.lockForConfiguration(nil)
                device.focusMode = .Locked
                device.unlockForConfiguration()
            }
            
        }
        
        func beginSession() {
            
            configureDevice()
            
            var err : NSError? = nil
            captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
            
            if err != nil {
                println("error: \(err?.localizedDescription)")
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            self.view.layer.addSublayer(previewLayer)
            previewLayer?.frame = self.view.layer.frame
            captureSession.startRunning()
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
