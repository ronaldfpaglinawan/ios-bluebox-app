//
//  ScannerViewController.swift
//  Blue Box
//
//  Created by Ronald F. Paglinawan on 25/08/2016.
//  Copyright © 2016 Harrison Grierson. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController , AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var qrCodeFrameView: UIView?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    // Added to support different barcodes
    let supportedBarCodes = [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        messageLabel.text = "No QR code is detected"
        startCamera(view.layer.bounds)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //print("view frame: \(view.layer.bounds)")
        //startCamera(view.layer.bounds)
    }
    
    func startCamera(_ cameraFrame: CGRect) {
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Detect all the supported bar code
            captureMetadataOutput.metadataObjectTypes = supportedBarCodes
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.connection.videoOrientation = .landscapeRight
            
            /* // set the camera orientation
            let orientation: UIDeviceOrientation = UIDevice.currentDevice().orientation
            switch (orientation) {
            case .Portrait:
                videoPreviewLayer?.connection.videoOrientation = .Portrait
                
            case .LandscapeRight:
                videoPreviewLayer?.connection.videoOrientation = .LandscapeRight
                
            case .LandscapeLeft:
                videoPreviewLayer?.connection.videoOrientation = .LandscapeLeft
                
            default:
                videoPreviewLayer?.connection.videoOrientation = .Portrait
            }
            */
            
            videoPreviewLayer?.frame = cameraFrame
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture
            captureSession?.startRunning()
            
            
            // Move the message label & logo to the top view
            view.bringSubview(toFront: messageLabel)
            view.bringSubview(toFront: logoImage)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = Utility().UIColorFromHex(AppConstants.Colors.kYellowGreen, alpha: 1.0).cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        // Here we use filter method to check if the type of metadataObj is supported
        // Instead of hardcoding the AVMetadataObjectTypeQRCode, we check if the type
        // can be found in the array of supported bar codes.
        if supportedBarCodes.contains(metadataObj.type) {
            //        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                 //print("metadataObj string: \(metadataObj.stringValue)")
                
                if metadataObj.stringValue != "HG Blue Box" {
                    messageLabel.text = "Invalid QR code"
                    
                } else {
                    DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                        
                        DispatchQueue.main.async {
                            self.messageLabel.text = "Correct QR code. Proceed"
                            self.captureSession?.stopRunning()
                            
                            let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let vc : TabBarController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarPage") as! TabBarController
                            self.present(vc, animated: true, completion: nil)
                        }
                    }
                    
                }
            }
        }
    }
    
}
