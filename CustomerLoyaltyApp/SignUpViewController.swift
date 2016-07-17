//
//  SignUpViewController.swift
//  CustomerLoyaltyApp
//
//  Created by Emmancipate Musemwa on 29/06/2016.
//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var userEmailAddressTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    @IBOutlet weak var userPasswordRepeatTextField: UITextField!
    @IBOutlet weak var userFirstNameTextField: UITextField!
    @IBOutlet weak var userLastNameTextField: UITextField!
    @IBOutlet weak var userDateOfBirthTextField: UITextField!
    @IBOutlet weak var userGenderTextField: UITextField!
    @IBOutlet weak var userPhoneNumberTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancelButtonTapped(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

  
    @IBAction func signUpButtonTapped(sender: AnyObject) {
        
        let userEmail = userEmailAddressTextField.text
        let userPassword = userPasswordTextField.text
        let userPasswordRepeat = userPasswordRepeatTextField.text
        let userFirstName = userFirstNameTextField.text
        let userLastName = userLastNameTextField.text
        let userDob = userDateOfBirthTextField.text
        let userGender = userGenderTextField.text
        let userPhone = userPhoneNumberTextField.text
       
        //Check if passwords match
        if(userPassword != userPasswordRepeat)
        {
        //Display alert
            displayAlertMessage("Passwords do not match")
            return
        
        }
        
        //Check if the fields are not empty
    
        if(userEmail!.isEmpty || userPassword!.isEmpty || userFirstName!.isEmpty || userLastName!.isEmpty || userDob!.isEmpty || userGender!.isEmpty || userPhone!.isEmpty)
        
        {
          //Display an alert message
           displayAlertMessage("All fields are required to fill in")
           return
            
       }
        
        
       
        
       
        //Activity indicator
        
        
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        spinningActivity.labelText = "Loading"
        spinningActivity.detailsLabelText = "Please wait"
        // Send HTTP POST
        
         let myUrl = NSURL(string: "http://emmancipatemusemwa.com/CustomerLoyaltyAppPHPMySQL/SourceFiles/scripts/registerUser.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "userEmail=\(userEmail!)&userPassword=\(userPassword!)&userFirstName=\(userFirstName!)&userLastName=\(userLastName!)&userPhone=\(userPhone!)&userDob=\(userDob!)&userGender=\(userGender!)";
        
         //let postString = "userEmail=epmkp@gmail.com&userPassword=password&userFirstName=eman&userLastName=mw&userPhone=m&userDob=05-05-05&userGender=M";
        
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
                            let myAlert = UIAlertController(title: "Alert", message: "Registration successful", preferredStyle: UIAlertControllerStyle.Alert);
                            
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
    

}
