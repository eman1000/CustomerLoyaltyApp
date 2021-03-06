//
//  MerchantDetailsTableViewController.swift
//  CustomerLoyaltyApp
//
//  Created by Emmancipate Musemwa on 09/07/2016.
//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MerchantDetailsTableViewController: UITableViewController {
    
    var viaSegue: Merchant?
    
    @IBOutlet weak var merchantNameLabel: UILabel!
    
    @IBOutlet weak var overLayView: UIView!
    //@IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var detailBgImage: UIImageView!
    
    @IBOutlet weak var logoImageView: UIImageView!
   
    @IBOutlet weak var descriptionLabel: UILabel!
   
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    @IBOutlet weak var addressLineOneLabel: UILabel!

    @IBOutlet weak var addressLineTwoLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    
    @IBOutlet weak var stateCountryLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var facebookLabel: UILabel!
    
    //Image Cache Declaration
    var imageCache = NSCache()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //transparent navigation bar
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
       self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
        
        
        
               overLayView?.backgroundColor = UIColor(red: 0,green: 0,blue: 0,alpha: 0.5)
        
        tableView.rowHeight = 250.0
         //self.wrapperView.clipsToBounds = true
         merchantNameLabel.text = viaSegue?.merchant_name
        
        phoneNumberLabel.text = "+6" + (viaSegue?.merchant_phone)!
        
        descriptionLabel.numberOfLines = 0
      
        
        descriptionLabel.text = viaSegue?.merchant_description
        descriptionLabel.sizeToFit()
        
        addressLineOneLabel.text = viaSegue?.merchant_address_line_one
        
        addressLineTwoLabel.text = (viaSegue?.merchant_address_line_two)! + " "  + (viaSegue?.merchant_city)! + " " +  (viaSegue?.merchant_zipcode)!
        stateCountryLabel.text = (viaSegue?.merchant_state)! + " " + (viaSegue?.merchant_country)!
        
         //facebookLabel.text = viaSegue?.merchant_facebook
        
        websiteLabel.text = viaSegue?.merchant_website
        emailAddressLabel.text = viaSegue?.merchant_email
        
        
        
        
        //background image with cache
        
        if let bgImageURL = (viaSegue!.bg_image)  as? String {
            
            if let image = imageCache.objectForKey(bgImageURL) as? UIImage {
                
                detailBgImage.image = image
            }else{
                
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: bgImageURL)!, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    self.imageCache.setObject(image!, forKey: bgImageURL)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.detailBgImage.image = image
                        
                    })
                    
                }).resume()
                
            }
            
            
        }
        
        
        
        
        
        
        //round logo
        
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2
        
       logoImageView.clipsToBounds = true
        
        logoImageView.layer.borderColor = UIColor.whiteColor().CGColor
        logoImageView.layer.borderWidth = 3
        
     
        
        
        
        if let logoImageURL = (viaSegue!.logo_image)  as? String {
            
            if let image = imageCache.objectForKey(logoImageURL) as? UIImage {
                
               logoImageView.image = image
            }else{
                
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: logoImageURL)!, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    self.imageCache.setObject(image!, forKey: logoImageURL)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.logoImageView.image = image
                        
                    })
                    
                }).resume()
                
            }
            
            
        }


        
       //Location
        var latitude:Double = ((viaSegue?.latitude)! as NSString).doubleValue
        var longitude:Double = ((viaSegue?.longitude)! as NSString).doubleValue
        
        var location = CLLocationCoordinate2DMake(latitude, longitude)
        
        
        var span = MKCoordinateSpanMake(0.002, 0.002)
        var region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(
            region, animated: true)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = viaSegue?.merchant_name
        
        mapView.addAnnotation(annotation)
        
        //category
        
        let category: Int = ((viaSegue?.merchant_category)! as NSString).integerValue
        
        switch category {
        case 1:
            categoryLabel.text = "Restaurant"
            break
        case 2:
            categoryLabel.text = "Cafe'"
            break
            
        case 3:
            categoryLabel.text = "Coffee Shop"
            break
        case 4:
            categoryLabel.text = "Arts & Entertainment"
            break
        case 5:
            categoryLabel.text = "Others"
            break
        case 6:
            categoryLabel.text = "Athletics & Sports"
            break
        default:
            break
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    
    //Open Google Maps
    
    
    
   

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 9
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    

    @IBAction func facebookButtonTapped(sender: AnyObject) {
        
        var  fbURL = viaSegue?.merchant_facebook
        
        var fbURLWeb: NSURL = NSURL(string: fbURL!)!
       
        
        
            // open in safari
            UIApplication.sharedApplication().openURL(fbURLWeb)
        
        
    }
   

}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
