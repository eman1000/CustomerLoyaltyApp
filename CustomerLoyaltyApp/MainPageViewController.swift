

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
    
    let refreshContol:UIRefreshControl = UIRefreshControl()
    
    //location CLL declaration
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    
    //Image Cache Declaration
    var imageCache = NSCache()
    let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
    @IBOutlet weak var myTableView: UITableView!
    let merchantLoadURL = "http://emmancipatemusemwa.com/CustomerLoyaltyAppPHPMySQL/SourceFiles/scripts/getMerchant.php";
    var merchants = [Merchant]()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredMerchants = [Merchant]()
   override func viewDidLoad() {
        
        //navigation bar bg
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        //navigation title
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
        imageView.contentMode = .ScaleAspectFit
        imageView.image =  UIImage(named: "logo")
        self.navigationItem.titleView = imageView
        
        //refreshh
        
        refreshContol.addTarget(self, action: "uiRefreshControlAction", forControlEvents: .ValueChanged)
        self.myTableView.addSubview(refreshContol)
        self.refreshContol.backgroundColor = UIColor.blackColor()
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        myTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.barStyle = UIBarStyle.Black
        searchController.searchBar.searchBarStyle = UISearchBarStyle.Minimal
        searchController.searchBar.tintColor = UIColor.whiteColor()
        
        //location
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        //table view bg
        
        self.myTableView.backgroundColor = UIColor(patternImage: UIImage(named: "grad_bg")!)
       myTableView.rowHeight = 250.0
        
        
        super.viewDidLoad()
        //remove space at the top of tableview
        
        // self.myTableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
    
        getMerchants()
        
        // Do any additional setup after loading the view.
        
    }
    //refresh funtion
    
    func uiRefreshControlAction(){
        
        self.myTableView.reloadData()
        self.refreshContol.endRefreshing()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active && searchController.searchBar.text != "" {
            return filteredMerchants.count
        }
        return merchants.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell

        var data: Merchant!
        
        if searchController.active && searchController.searchBar.text != "" {
            data = filteredMerchants[indexPath.row]
            
        } else {
           data = merchants[indexPath.row]
        }
        
        merchants.sortInPlace({ $0.distanceN < $1.distanceN })
        
        //Configure cell
        cell.distanceLabel.text = String(format: "%.2f", data.distanceN) + "km"
        cell.overlayView?.backgroundColor = UIColor(red: 0,green: 0,blue: 0,alpha: 0.5)
        cell.merchantNameLabel?.text = data.merchant_name
        cell.merchantCity?.text = data.merchant_city
        
          let favID = Int(data.favourite_id)
        
        if(favID < 1){
            
            cell.favButton.setImage(UIImage(named: "Hearts-50.png"), forState: UIControlState.Normal)
        }else{
            
             cell.favButton.setImage(UIImage(named: "Hearts-Filled-50.png"), forState: UIControlState.Normal)
        
        }
        
        //background image with cache
        
        if let bgImageURL = data.bg_image  as? String {
            
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
        
        if let logoImageURL = data.logo_image  as? String {
            
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
        let merchantLoadURL = "http://emmancipatemusemwa.com/CustomerLoyaltyAppPHPMySQL/SourceFiles/scripts/getMerchant.php";
        
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
                merchant.merchant_id = jsonMerchant["merchant_id"] as! String
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
                 merchant.favourite_id = jsonMerchant["favourite_id"] as! String
              
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
    
    
    
    //Add to favourites
   
    @IBAction func addFavourite(sender: AnyObject) {
        let cell = sender.superview!!.superview as! TableViewCell
        let indexPath = myTableView.indexPathForCell(cell)
         var data: Merchant!
          data = merchants[indexPath!.row]
       let  merchantID  = data.merchant_id
        //Activity indicator
     
         sender.setImage(UIImage(named: "Hearts-Filled-50.png"), forState: UIControlState.Normal)
        
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        spinningActivity.labelText = "Loading"
        spinningActivity.detailsLabelText = "Please wait"
        // Send HTTP POST
        
        let myUrl = NSURL(string: "http://emmancipatemusemwa.com/CustomerLoyaltyAppPHPMySQL/SourceFiles/scripts/addFavourites.php");
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let postString = "userId=\(userId!)&merchantID=\(merchantID)";
        
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
                        let merchantID = parseJSON["merchantID"] as? String
                        
                        if( userId != nil )
                        {
                            let myAlert = UIAlertController(title: "Alert", message: "Merchant successfully added to your favourites", preferredStyle: UIAlertControllerStyle.Alert);
                            
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
    
    //Send Data Via Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier{
            
            switch identifier {
            case "ShowDetails":
                let merchantDetailVC = segue.destinationViewController as! MerchantDetailsTableViewController
                let indexPath = self.myTableView.indexPathForSelectedRow
                var data: Merchant!
                
                if searchController.active && searchController.searchBar.text != "" {
                    data = filteredMerchants[indexPath!.row]
                    
                } else {
                    data = merchants[indexPath!.row]
                }
                
                let dataToPass = data
                
                
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
        print((currentCoordinate?.latitude)! + (currentCoordinate?.longitude)!)
        
    }
    
    
    func locationManager(manager: CLLocationManager,
                         didFailWithError error: NSError) {
        
        print("Errors" + error.localizedDescription)
        
        
    }
    //filter search function
    
    func filterContentForSearchText(searchText: String) {
        filteredMerchants = merchants.filter { merchant in
            return String(merchant.merchant_name).lowercaseString.containsString(searchText.lowercaseString)
        }
        myTableView.reloadData()
    }
    
    
    
    func convertStringToInt(string: String) -> Int!
    {
    let resultNum = Int(string)
        return resultNum
    
    
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



//search extension

extension MainPageViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}




