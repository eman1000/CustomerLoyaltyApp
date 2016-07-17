//
//  SideViewController.swift
//  CustomerLoyaltyApp
//
//  Created by Emmancipate Musemwa on 02/07/2016.
//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.
//

import UIKit

class SideViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    @IBOutlet weak var profilePhotoImageView: UIImageView!
    @IBOutlet weak var userFullNameLabel: UILabel!
    
    //Image Cache Declaration
    var imageCache = NSCache()
    
    var menuItems:[String] = ["Main","Scan QR Code","Cards", "About", "Sign out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Round profile pic
        
        //round logo
        
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width / 2
        
        profilePhotoImageView.clipsToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    //add overrive function
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        let userFistName = NSUserDefaults.standardUserDefaults().stringForKey("userFirstName")!
        
        let userLastName = NSUserDefaults.standardUserDefaults().stringForKey("userLastName")!
        
        let userFullName = userFistName + " " + userLastName
        userFullNameLabel.text = userFullName
        
        
        
        
        
        
        if (profilePhotoImageView.image == nil) {
            
            //profile Image image with cache
            let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
            
            if let imageUrl = NSURL(string:"http://emmancipatemusemwa.com/CustomerLoyaltyAppPHPMySQL/SourceFiles/profile-pictures/\(userId!)/user-profile.jpg") {
                
                if let image = imageCache.objectForKey(imageUrl) as? UIImage {
                    
                    profilePhotoImageView.image = image
                }else{
                    
                    let imageURL:String  = String(imageUrl)
                    
                    NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: imageURL)!, completionHandler: { (data, response, error) -> Void in
                        if error != nil {
                            print(error)
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        
                        self.imageCache.setObject(image!, forKey: imageUrl)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            
                            self.profilePhotoImageView.image = image
                            
                        })
                        
                    }).resume()
                    
                }
                
                
            }
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //Change profile picture button
    
    
    @IBAction func selectProfilePhotoButtonTapped(sender: AnyObject) {
        
        let myImagePicker = UIImagePickerController()
        myImagePicker.delegate = self
        myImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myImagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        profilePhotoImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.dismissViewControllerAnimated(true, completion: nil)
        
        
        //progress indicator
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.labelText = "Loading"
        spinningActivity.detailsLabelText = "Please wait"
        
        myImageUploadRequest()
    }
    
    
    func myImageUploadRequest()
    {
        let myUrl = NSURL(string: "http://emmancipatemusemwa.com/CustomerLoyaltyAppPHPMySQL/SourceFiles/scripts/imageUpload.php");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let userId:String? = NSUserDefaults.standardUserDefaults().stringForKey("userId")
        
        let param = [
            "userId" : userId!
        ]
        
        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(profilePhotoImageView.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data:NSData?, response:NSURLResponse?, error:NSError?) -> Void in
            
            //Dismiss progress indicator loading. Whill need to use dipach async coz we are in another function
            
            dispatch_async(dispatch_get_main_queue())
            {
                
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }
            
            if error != nil {
                // Display an alert message
                return
            }
            
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                dispatch_async(dispatch_get_main_queue())
                {
                    
                    if let parseJSON = json {
                        // let userId = parseJSON["userId"] as? String
                        
                        // Display an alert message
                        let userMessage = parseJSON["message"] as? String
                        self.displayAlertMessage(userMessage!)
                    } else {
                        // Display an alert message
                        let userMessage = "Could not upload image at this time"
                        self.displayAlertMessage(userMessage)
                    }
                }
            } catch
            {
                print(error)
            }
            
        }).resume()
        
        
        
    }
    
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    
    func generateBoundaryString() -> String {
        // Create and return a unique string.
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
    func displayAlertMessage(userMessage:String)
    {
        let myAlert = UIAlertController(title: "Alert", message:userMessage, preferredStyle: UIAlertControllerStyle.Alert);
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:nil)
        
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil)
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        
        return menuItems.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        //instatiate table view cell
        
        var myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as! UITableViewCell
        
        myCell.textLabel?.text = menuItems[indexPath.row]
        
        return myCell
        
    }
    //for clicking side menu links
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
        
    {
        
        switch(indexPath.row)
        {
        case 0:
            //instatiate main page
            var mainPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MainPageViewController") as! MainPageViewController
            
            //Wrap into navigtion controller
            var mainPageNav = UINavigationController(rootViewController: mainPageViewController)
            
            //set to navigation drawer by refernecing app delegate coz it was created in appdelegate
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = mainPageNav
            
            //Close side panel
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            break
            
        case 1:
            
            //instatiate main page
            var scanqrPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ScannerViewController") as! ScannerViewController
            
            //Wrap into navigtion controller
            var scanqrPageNav = UINavigationController(rootViewController: scanqrPageViewController)
            
            //set to navigation drawer by refernecing app delegate coz it was created in appdelegate
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = scanqrPageNav
            
            //Close side panel
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
            
            
        case 2:
            
            //instatiate main page
            var cardsPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("CardsTableViewController") as! CardsTableViewController
            
            //Wrap into navigtion controller
            var cardsPageNav = UINavigationController(rootViewController: cardsPageViewController)
            
            //set to navigation drawer by refernecing app delegate coz it was created in appdelegate
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = cardsPageNav
            
            //Close side panel
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
            
            
        case 3:
            
            //instatiate main page
            var aboutPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController") as! AboutViewController
            
            //Wrap into navigtion controller
            var aboutPageNav = UINavigationController(rootViewController: aboutPageViewController)
            
            //set to navigation drawer by refernecing app delegate coz it was created in appdelegate
            
            var appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.drawerContainer!.centerViewController = aboutPageNav
            
            //Close side panel
            appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
            
            break
            
            
            
        case 4:
            
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userFirstName")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userLastName")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userId")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userDob")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userEmail")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userGender")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("userPhone")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            
            let signInPage = self.storyboard?.instantiateViewControllerWithIdentifier("SignInViewController") as! SignInViewController
            
            let signInNav = UINavigationController(rootViewController: signInPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate
            appDelegate?.window??.rootViewController = signInNav
            
            break
            
            
            
        default:
            print("Not handled")
            
        }
        
    }
    
    
    
    
    
}


extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}