

//



//  MainPageViewController.swift



//  CustomerLoyaltyApp



//



//  Created by Emmancipate Musemwa on 30/06/2016.



//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.



//



import UIKit
import CoreLocation

class MainPageViewController: UIViewController, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    //location CLL declaration
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    
    //Image Cache Declaration
    var imageCache = NSCache()
    
    @IBOutlet weak var myTableView: UITableView!
    
    let merchantLoadURL = "http://emmancipatemusemwa.com/CustomerLoyaltyAppPHPMySQL/SourceFiles/scripts/getMerchant.php";
    
    var merchants = [Merchant]()
    
    
    
    override func viewDidLoad() {
        
        //location
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //table view bg
        
        self.myTableView.backgroundColor = UIColor(patternImage: UIImage(named: "grad_bg")!)
        
        //navigation bar bg
        // UINavigationBar.appearance().barTintColor = UIColor.blackColor()
        
        let img = UIImage(named: "nav-bg")
        UINavigationBar.appearance().tintColor = UIColor.orangeColor()
        
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
        
        merchants.sortInPlace({ $0.distanceN < $1.distanceN })
        
        //Configure cell
        cell.distanceLabel.text = String(format: "%.2f", merchants[indexPath.row].distanceN) + "km"
        cell.overlayView?.backgroundColor = UIColor(red: 0,green: 0,blue: 0,alpha: 0.5)
        cell.merchantNameLabel?.text = merchants[indexPath.row].merchant_name
        cell.merchantCity?.text = merchants[indexPath.row].merchant_city
        
        
        //background image with cache
        
        if let bgImageURL = merchants[indexPath.row].bg_image  as? String {
            
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
        
        if let logoImageURL = merchants[indexPath.row].logo_image  as? String {
            
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
        
        //sort Merchant name
        
        // merchants = merchants.sort({ current, next in
        //     return current.merchant_name < next.merchant_name
        //  })
        return cell
    }
    
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
                merchant.merchant_website = jsonMerchant["merchant_website"] as! String
                merchant.merchant_email = jsonMerchant["merchant_email"] as! String
                
                
                //location
                
                
                var myLat = currentCoordinate?.latitude
                var myLong = currentCoordinate?.longitude
                let lat:Double = ((merchant.latitude) as NSString).doubleValue
                let long:Double = ((merchant.longitude) as NSString).doubleValue
                let mylocation = CLLocation(latitude: myLat!, longitude: myLong!)
                let location2 = CLLocation(latitude: lat , longitude: long)
                let distance = location2.distanceFromLocation(mylocation)
                let distanceKM = distance / 1000
                merchant.distanceN = distanceKM
                
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
    
    
    
    
    //MARK: -LOCATION
    
    func locationManager(manager: CLLocationManager!,
                         didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last
        currentCoordinate = manager.location?.coordinate
        //self.locationManager.stopUpdatingLocation()
        //print(currentCoordinate?.latitude)
        
    }
    
    
    func locationManager(manager: CLLocationManager,
                         didFailWithError error: NSError) {
        
        print("Errors" + error.localizedDescription)
        
        
    }
    
}





