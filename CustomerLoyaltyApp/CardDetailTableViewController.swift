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
     //var merchants = [Merchant]()


    
    //Image Cache Declaration
    var imageCache = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getGiftDetails()
        self.tableView.reloadData();
        //table view bg
        
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "grad_bg")!)
        
        //navigation bar bg
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
     
        
        tableView.rowHeight = 524.0
        
        
        
        //merchantNameLabel.text = viaCardsSegue?.merchant_name
        
        //giftName.text = String(gifts[0])
        


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
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        

        return gifts.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("giftCell", forIndexPath: indexPath) as! GiftTableViewCell
        cell.merchantNameLabel?.text = gifts[indexPath.row].merchant_name
        cell.giftNameLabel?.text = gifts[indexPath.row].gift_name
        cell.descriptionLabel?.text = gifts[indexPath.row].gift_description
        
        
        //background image with cache
        
        if let bgImageURL = gifts[indexPath.row].bg_image as? String {
            
            if let image = imageCache.objectForKey(bgImageURL) as? UIImage {
                
                cell.bgImageView.image = image
            }else{
                
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: bgImageURL)!, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    self.imageCache.setObject(image!, forKey: bgImageURL)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        cell.bgImageView.image = image
                        
                    })
                    
                }).resume()
                
            }
            
        }
        
        
        //logo image with catche
        //round logo
        
        cell.logoImageView.layer.cornerRadius = cell.logoImageView.frame.size.width / 2
        
        cell.logoImageView.clipsToBounds = true
        
        cell.logoImageView.layer.borderColor = UIColor.whiteColor().CGColor
        cell.logoImageView.layer.borderWidth = 3
        
        if let logoImageURL = gifts[indexPath.row].logo_image  as? String {
            
            if let image = imageCache.objectForKey(logoImageURL) as? UIImage {
                
                cell.logoImageView.image = image
            }else{
                
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: logoImageURL)!, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    self.imageCache.setObject(image!, forKey: logoImageURL)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        cell.logoImageView.image = image
                        
                    })
                    
                }).resume()
                
            }
            
            
        }
        
        
        //gift image with cache
        
        if let giftImageURL = gifts[indexPath.row].gift_image as? String {
            
            if let image = imageCache.objectForKey(giftImageURL) as? UIImage {
                
                cell.bgImageView.image = image
            }else{
                
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: giftImageURL)!, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    self.imageCache.setObject(image!, forKey: giftImageURL)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        cell.giftImageView.image = image
                        
                    })
                    
                }).resume()
                
            }
            
        }
        //sort Merchant name
        
        // merchants = merchants.sort({ current, next in
        //     return current.merchant_name < next.merchant_name
        //  })
        
        return cell

        
        
    }
    
    func getGiftDetails() {
        let merchantLoadURL = "http://emmancipatemusemwa.com/CustomerLoyaltyAppPHPMySQL/SourceFiles/scripts/getGift.php?merchantId=7";
        
        let request = NSURLRequest(URL: NSURL(string: merchantLoadURL)!)
        let urlSession = NSURLSession.sharedSession()
        let task = urlSession.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            if let error = error {
                print(error)
                return
            }
            
            //Parsing
            
            if let data = data {
                self.gifts = self.parseJsonData(data)
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.tableView.reloadData();
                })
            }
        })
        task.resume()
    }
    
    func parseJsonData(data: NSData) -> [Gift] {
        do {
            
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            
            
            //Parse Json Data
            
            
            
            let jsonMerchants = jsonResult?["merchants"] as! [AnyObject]
            
            for jsonMerchant in jsonMerchants {
                
                let gift = Gift()
                gift.merchant_id = jsonMerchant["merchant_id"] as! String
                gift.merchant_name = jsonMerchant["merchant_name"] as! String
               gift.bg_image = jsonMerchant["bg_image"] as! String
                gift.logo_image = jsonMerchant["logo_image"] as! String
                gift.gift_name = jsonMerchant["gift_name"] as! String
                gift.gift_description = jsonMerchant["gift_description"] as! String
                 gift.gift_image = jsonMerchant["gift_image"] as! String

                

                gifts.append(gift)
            }
            
        }catch {
            
            print(error)
        }
        return gifts
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
