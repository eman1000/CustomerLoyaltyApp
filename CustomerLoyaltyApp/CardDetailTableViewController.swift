//
//  CardDetailTableViewController.swift
//  CustomerLoyaltyApp
//
//  Created by Emmancipate Musemwa on 01/08/2016.
//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.
//

import UIKit

class CardDetailTableViewController: UITableViewController {
    
    var viaCardsSegue: Card?
    
    var gifts = [Gift]()

    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var cardBgImageView: UIImageView!
    
    @IBOutlet weak var merchantNameLabel: UILabel!
    
    @IBOutlet weak var giftImageView: UIImageView!
  
    @IBOutlet weak var giftName: UILabel!
    
    @IBOutlet weak var giftDescription: UILabel!
    //Image Cache Declaration
    var imageCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData();
        //table view bg
        
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "grad_bg")!)
        
        //navigation bar bg
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
     
        
        tableView.rowHeight = 250.0
        
        
        
        merchantNameLabel.text = viaCardsSegue?.merchant_name
      
        
        
        //round card
        
       cardBgImageView.clipsToBounds = true
        cardBgImageView.layer.borderColor = UIColor.whiteColor().CGColor
       cardBgImageView.layer.borderWidth = 3
        
        //background image with cache
        
        if let bgImageURL = (viaCardsSegue!.bg_image)  as? String {
            
            if let image = imageCache.objectForKey(bgImageURL) as? UIImage {
                
                cardBgImageView.image = image
            }else{
                
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: bgImageURL)!, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    self.imageCache.setObject(image!, forKey: bgImageURL)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        self.cardBgImageView.image = image
                        
                    })
                    
                }).resume()
                
            }
            
            
        }
        
        
        
        
        
        
        //round logo
        
        logoImageView.layer.cornerRadius = logoImageView.frame.size.width / 2
        
        logoImageView.clipsToBounds = true
        
        logoImageView.layer.borderColor = UIColor.whiteColor().CGColor
        logoImageView.layer.borderWidth = 3
        
        
        
        
        
        if let logoImageURL = (viaCardsSegue!.logo_image)  as? String {
            
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


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
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
