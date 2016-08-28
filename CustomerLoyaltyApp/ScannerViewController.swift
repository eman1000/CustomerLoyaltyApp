//
//  ScannerViewController.swift
//  CustomerLoyaltyApp
//
//  Created by Emmancipate Musemwa on 10/07/2016.
//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.
//

import AVFoundation
import UIKit

class ScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate{
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    

    @IBOutlet weak var scanSquareImageView: UIImageView!
    @IBOutlet weak var instructionLabel: UILabel!
    //@IBOutlet weak var scanResult: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
     
        
        //navigation bar bg
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]

        
    scanSquareImageView.image = UIImage(named: "scan_image")
        
        instructionLabel.text = "Please hover over QR code to scan"
     
        
        
        view.backgroundColor = UIColor.blackColor()
        captureSession = AVCaptureSession()
        
        let videoCaptureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            failed();
            return;
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession);
        previewLayer.frame = view.layer.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        view.layer.addSublayer(previewLayer);
        
        captureSession.startRunning();
    
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning not supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
        captureSession = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //Bring Views to front
        self.view .bringSubviewToFront(scanSquareImageView)
        
        self.view .bringSubviewToFront(instructionLabel)
        
        if (captureSession?.running == false) {
            captureSession.startRunning();
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.running == true) {
            captureSession.stopRunning();
        }
    }
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            let readableObject = metadataObject as! AVMetadataMachineReadableCodeObject;
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            foundCode(readableObject.stringValue);
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func foundCode(code: String) {
        
     //Qr Code Scanned
        
        //progress indicator
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.labelText = "Verifying Qr Code"
        spinningActivity.detailsLabelText = "Please wait"
        //post http request
        let myUrl = NSURL(string: "http://emmancipatemusemwa.com/CustomerLoyaltyAppPHPMySQL/SourceFiles/scripts/checkQr.php");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "qrCode=\(code)";
        
        
        
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            dispatch_async(dispatch_get_main_queue())
            {
                spinningActivity.hide(true)
                
                if(error != nil)
                {
                    //Display an alert message
                    let myAlert = UIAlertController(title: "Alert", message: error!.localizedDescription, preferredStyle: UIAlertControllerStyle.Alert);
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
                    myAlert.addAction(okAction);
                    self.presentViewController(myAlert, animated: true, completion: nil)
                    return
                }
                
                
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                    
                    if let parseJSON = json {
                        
                        let qrId = parseJSON["qrId"] as? String
                        let merchantID = parseJSON["merchantID"] as? String
                        if(qrId != nil)
                        {
                            
                           ///
                            //Qr Code Scanned
                            
                            //let userId = "3"
                            //let merchantID = "1"
                      
                            
                            
                            
                            
                            
                            
                            
                            
                            //Activity indicator
                            
                            
                            let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
                            
                            spinningActivity.labelText = "Updating your points please wait"
                            spinningActivity.detailsLabelText = "Please wait"
                            // Send HTTP POST
                            
                            //url to update card points
                             let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
                            
                            let myUrl = NSURL(string: "http://emmancipatemusemwa.com/CustomerLoyaltyAppPHPMySQL/SourceFiles/scripts/addPointToCard.php");
                            let request = NSMutableURLRequest(URL:myUrl!);
                            request.HTTPMethod = "POST";
                            
                            let postString = "userId=\(userId!)&merchantID=\(merchantID!)";
                            
                            print(userId)
                          
                            
                            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
                            
                            NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
                                
                                dispatch_async(dispatch_get_main_queue())
                                {
                                    
                                    spinningActivity.hide(true)
                                    
                                    if error != nil {
                                        self.displayAlertMessage(error!.localizedDescription)
                                        return
                                    }
                                    
                                    do {
                                        let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                                        
                                        if let parseJSON = json {
                                            
                                            let userId = parseJSON["userId"] as? String
                                            
                                            if( userId != nil)
                                            {
                                                let myAlert = UIAlertController(title: "Alert", message: "Points Updated", preferredStyle: UIAlertControllerStyle.Alert);
                                                
                                                let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){(action) in
                                                    
                                                    self.dismissViewControllerAnimated(true, completion: nil)
                                                }
                                                
                                                myAlert.addAction(okAction);
                                                self.presentViewController(myAlert, animated: true, completion: nil)
                                            } else {
                                                let errorMessage = parseJSON["message"] as? String
                                                if(errorMessage != nil)
                                                {
                                                    self.displayAlertMessage(errorMessage!)
                                                }
                                                
                                            }
                                            
                                        }
                                    } catch{
                                        print(error)
                                    }
                                    
                                    
                                    
                                }
                                
                            }).resume()
                            

                            
                            
                            
                            
                            ///
                            
                            
                            
                            
                        } else {
                            // display an alert message
                            let userMessage = parseJSON["message"] as? String
                            let myAlert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.Alert);
                            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
                            myAlert.addAction(okAction);
                            self.presentViewController(myAlert, animated: true, completion: nil)
                        }
                        
                    }
                } catch
                {
                    print(error)
                }
                
                
            }
            
            
            
        }).resume()
        
        
        
        
        
        //print(code)
        // print("some code")
        
        
        
        //Display an alert message
        //displayAlertMessage(code)
        // return
    }
    

    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Left Side Button With More items
    
    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
       
        

    }
    
    
    
    func displayAlertMessage(userMessage: String)
    {
        var myAlert = UIAlertController(title: "Alert", message:
            userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style:
            UIAlertActionStyle.Default, handler: nil)
        myAlert.addAction(okAction);
        self.presentViewController(myAlert, animated: true, completion: nil)
    }
    

    @IBAction func cancelSegue(sender: AnyObject) {
        self.performSegueWithIdentifier("customSegue", sender: self)
        
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
