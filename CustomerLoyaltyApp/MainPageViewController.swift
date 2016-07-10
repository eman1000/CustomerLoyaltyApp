

//



//  MainPageViewController.swift



//  CustomerLoyaltyApp



//



//  Created by Emmancipate Musemwa on 30/06/2016.



//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.



//







import UIKit







class MainPageViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    
    
   
   
    
    @IBOutlet weak var myTableView: UITableView!
    
    let merchantLoadURL = "http://localhost/CustomerLoyaltyAppPHPMySQL/SourceFiles/scripts/getMerchant.php";
    
    var merchants = [Merchant]()
    
    
    
    
    
    
    
    override func viewDidLoad() {
        myTableView.rowHeight = 250.0
        
        
        super.viewDidLoad()
        //remove space at the top of tableview
        
       // self.myTableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);


        

        getMerchants()
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        
        
        
        super.didReceiveMemoryWarning()
        
        
        
        // Dispose of any resources that can be recreated.
        
        
        
    }
    
    
    
    
    

    
    
    
    
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        
        return 1
        
        
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return merchants.count
        
        
        
    }
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        
        
        //Configure cell
        
        cell.overlayView?.backgroundColor = UIColor(red: 0,green: 0,blue: 0,alpha: 0.5)
        
        cell.merchantNameLabel?.text = merchants[indexPath.row].merchant_name
        
         cell.merchantCity?.text = merchants[indexPath.row].merchant_city
        
     
        
        let bgImage = merchants[indexPath.row].bg_image  as? String
        let bgImageUrl = NSURL(string:bgImage! )
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let bgImageData = NSData(contentsOfURL: bgImageUrl!)
            
            if(bgImageData != nil)
            {
                dispatch_async(dispatch_get_main_queue(),{
                   cell.bgImageView?.image = UIImage(data: bgImageData!)
                })
            }
            
        }
        
        //round logo
        
        cell.logoImageView.layer.cornerRadius = cell.logoImageView.frame.size.width / 2
        
        cell.logoImageView.clipsToBounds = true
        
        let logoImage = merchants[indexPath.row].logo_image  as? String
        let logoImageUrl = NSURL(string:logoImage! )
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let logoImageData = NSData(contentsOfURL: logoImageUrl!)
            
            if(logoImageData != nil)
            {
                dispatch_async(dispatch_get_main_queue(),{
                    cell.logoImageView?.image = UIImage(data: logoImageData!)
                })
            }
            
        }
        
        return cell
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*@IBAction func rightSideButtonTapped(sender: AnyObject) {
        
        
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        
        
        
        
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Right, animated: true, completion: nil)
        
        
        
    }*/
    
    // Left Side Button With More items
    
    @IBAction func leftSideButtonTapped(sender: AnyObject) {
        
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        
        appDelegate.drawerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
        
        
    }
   
    
    
    
    
    
    
    func getMerchants() {
        
        
        
        let request = NSURLRequest(URL: NSURL(string: merchantLoadURL)!)
        
        let urlSession = NSURLSession.sharedSession()
        
        let task = urlSession.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            
            
            
            if let error = error {
                
                print(error)
                
                return
                
            }
            
            //Parsing
            
            
            
            if let data = data {
                
                
                
                self.merchants = self.parseJsonData(data)
                
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    self.myTableView.reloadData();
                    
                    
                    
                })
                
                
                
            }
            
            
            
            
            
            
            
        })
        
        task.resume()
        
        
        
        
        
    }
    
    
    
    
    
    func parseJsonData(data: NSData) -> [Merchant] {
        
        
        
        do {
            
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            
            
            
            //Parse Json Data
          
            
            
            let jsonMerchants = jsonResult?["merchants"] as! [AnyObject]
            
            for jsonMerchant in jsonMerchants {
                
                
                
                let merchant = Merchant()
                
                merchant.merchant_name = jsonMerchant["merchant_name"] as! String
                
                merchant.bg_image = jsonMerchant["bg_image"] as! String
                merchant.logo_image = jsonMerchant["logo_image"] as! String
                
                merchant.merchant_city = jsonMerchant["merchant_city"] as! String
                merchant.merchant_description = jsonMerchant["merchant_description"] as! String
                merchant.merchant_phone = jsonMerchant["merchant_phone"] as! String
                
                merchant.merchant_address_line_one = jsonMerchant["merchant_address_line_one"] as! String
                merchant.merchant_address_line_two = jsonMerchant["merchant_address_line_two"] as! String
                merchant.merchant_category = jsonMerchant["merchant_category"] as! String
                 merchant.merchant_country = jsonMerchant["merchant_country"] as! String
                merchant.merchant_state = jsonMerchant["merchant_state"] as! String
                merchant.merchant_country = jsonMerchant["merchant_country"] as! String
                merchant.latitude = jsonMerchant["latitude"] as! String
                 merchant.longitude = jsonMerchant["longitude"] as! String
                merchant.merchant_facebook = jsonMerchant["merchant_facebook"] as! String
                
                
                
                
                
               
                 
                
                
                merchants.append(merchant)
                
                
                
                
                
                
                
            }
            
            
            
        }catch {
            
            print(error)
            
            
            
            
            
        }
        
        
        
        return merchants
        
        
        
        
        
    }
    
    
    //Send Data Via Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier{
        
            switch identifier {
            case "ShowDetails":
                let merchantDetailVC = segue.destinationViewController as! MerchantDetailsTableViewController
                
              
                let indexPath = self.myTableView.indexPathForSelectedRow
                let dataToPass = merchants[indexPath!.row]
                
                    merchantDetailVC.viaSegue = dataToPass
                
                
            default:
                break
            }
        
        
        
        
        
        }
        
        
        
        
    }
 
    
    
    override func viewWillAppear(animated: Bool) {
        //self.navigationController!.navigationBar.barTintColor = UIColor(red: 0,green: 0,blue: 0,alpha: 0.5)
        
        
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = nil
    
       self.navigationController?.navigationBar.translucent = true

    }
    
    
  
    
    
}





