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
        
         let bgImage = viaSegue?.bg_image
        
        let bgImageUrl = NSURL(string:bgImage! )
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let bgImageData = NSData(contentsOfURL: bgImageUrl!)
            
            if(bgImageData != nil)
            {
                dispatch_async(dispatch_get_main_queue(),{
                    self.detailBgImage?.image = UIImage(data: bgImageData!)
                })
            }
            
        }
        
        
        
        //round logo
        
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2
        
       logoImageView.clipsToBounds = true
        
        let logoImage = viaSegue!.logo_image
        let logoImageUrl = NSURL(string:logoImage )
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let logoImageData = NSData(contentsOfURL: logoImageUrl!)
            
            if(logoImageData != nil)
            {
                dispatch_async(dispatch_get_main_queue(),{
                    self.logoImageView?.image = UIImage(data: logoImageData!)
                })
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
    
   

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
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
    


}

extension String {
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.max)
        
        let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
