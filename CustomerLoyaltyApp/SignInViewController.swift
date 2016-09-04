//
//  SignInViewController.swift
//  CustomerLoyaltyApp
//
//  Created by Emmancipate Musemwa on 30/06/2016.
//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    

    @IBOutlet weak var userEmailAddressTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
      

        // Do any additional setup after loading the view.
    }
    
    //refreshh function
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    @IBAction func signInButtonTapped(sender: AnyObject) {
        
        let userEmailAddress = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        
        //Check if user email and password fields are empty
        
        if(userEmailAddress!.isEmpty || userPassword!.isEmpty)
        {
        
        //Display an Alert Message
            
            var myAlert = UIAlertController(title: "Alert", message:"All fields are required to fill in", preferredStyle: UIAlertControllerStyle.Alert);
            
            let okAction = UIAlertAction(title: "OK", style:
                UIAlertActionStyle.Default, handler: nil)
            myAlert.addAction(okAction);
            self.presentViewController(myAlert, animated: true, completion: nil)
            return
        
        }
        
        //progress indicator
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.labelText = "Loading"
        spinningActivity.detailsLabelText = "Please wait"
        
        //post http request
        let myUrl = NSURL(string: "http://emmancipatemusemwa.com/CustomerLoyaltyAppPHPMySQL/SourceFiles/scripts/userSignin.php");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "userEmail=\(userEmailAddress!)&userPassword=\(userPassword!)";
        
        //let postString = "userEmail=emanzoelife@yahoo.com&userPassword=123456"
        
        
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
                        
                        let userId = parseJSON["userId"] as? String
                        if(userId != nil)
                        {
                            
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["userFirstName"], forKey: "userFirstName")
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["userLastName"], forKey: "userLastName")
                             NSUserDefaults.standardUserDefaults().setObject(parseJSON["userDob"], forKey: "userDob")
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["userGender"], forKey: "userGender")
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["userPhone"], forKey: "userPhone")
                             NSUserDefaults.standardUserDefaults().setObject(parseJSON["userEmail"], forKey: "userEmail")
                            
                            
                            NSUserDefaults.standardUserDefaults().setObject(parseJSON["userId"], forKey: "userId")
                            NSUserDefaults.standardUserDefaults().synchronize()
                            
                            // take user to a protected page
                            
                             let mainPage = self.storyboard?.instantiateViewControllerWithIdentifier("MyTabBarViewController") as! MyTabBarViewController
                             
                             let mainPageNav = UINavigationController(rootViewController: mainPage)
                             let appDelegate = UIApplication.sharedApplication().delegate
                             
                             appDelegate?.window??.rootViewController = mainPageNav
                            
                            
                            //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            
                           // appDelegate.buildNavigationDrawer()
                              
                            
                            //take user to navigation drawer instead of protected page
                            
                            //instatiate app delegate
                            //let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            
                           // appDelegate.buildNavigationDrawer()
                            
                            
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
        
    }

}
