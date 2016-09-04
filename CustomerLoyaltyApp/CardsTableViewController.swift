//
//  CardsTableViewController.swift
//  CustomerLoyaltyApp
//
//  Created by Emmancipate Musemwa on 12/07/2016.
//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.
//

import UIKit

class CardsTableViewController: UITableViewController {


    
   // @IBOutlet weak var myTableView: UITableView!
    //@IBOutlet weak var pointViewOne: UIView!
    
    
    //let id = NSUserDefaults.standardUserDefaults().stringForKey("userId")
    
   let userId = NSUserDefaults.standardUserDefaults().stringForKey("userId")
    
    //Image Cache Declaration
    var imageCache = NSCache()
  
    
   
    
   
    
    var cards = [Card]()
    
    
    
    
    
    
    
    override func viewDidLoad() {
        //table view bg
        
       tableView.backgroundColor = UIColor(patternImage: UIImage(named: "grad_bg")!)
        
        //navigation bar bg
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        
       // myTableView.rowHeight = 250.0
        
        
        super.viewDidLoad()
        //remove space at the top of tableview
        
        // self.myTableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        
        
        
        
        getCards()
        
        
        
        
        
        
        
        // Do any additional setup after loading the view.
        
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    override func viewDidAppear(animated: Bool) {

    }
    
    
    
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        
        
        
        super.didReceiveMemoryWarning()
        
        
        
        // Dispose of any resources that can be recreated.
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        
        
        return 1
        
        
        
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return cards.count
        
        
        
    }
    
    
    
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cardCell", forIndexPath: indexPath) as! CardTableViewCell
        
        
        
        //Configure cell
        
       // cell.overlayView?.backgroundColor = UIColor(red: 0,green: 0,blue: 0,alpha: 0.5)
        
        cell.merchantNameLabel?.text = cards[indexPath.row].merchant_name
        //cell.totalPoints?.text = cards[indexPath.row].points_accumulated
        
      
        
     
        
        let bgImage = cards[indexPath.row].bg_image  as? String
        let bgImageUrl = NSURL(string:bgImage! )
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            
            let bgImageData = NSData(contentsOfURL: bgImageUrl!)
            
            if(bgImageData != nil)
            {
                dispatch_async(dispatch_get_main_queue(),{
                    cell.cardBgImageView?.image = UIImage(data: bgImageData!)
                })
            }
            
        }
        
        
        
        //background image with cache
        
        if let bgImageURL = cards[indexPath.row].bg_image  as? String {
            
            if let image = imageCache.objectForKey(bgImageURL) as? UIImage {
                
                cell.cardBgImageView.image = image
            }else{
                
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: bgImageURL)!, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    self.imageCache.setObject(image!, forKey: bgImageURL)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        cell.cardBgImageView.image = image
                        
                    })
                    
                }).resume()
                
            }
            
            
        }
        
        //round logo
        
        cell.merchantLogoImageView.layer.cornerRadius = cell.merchantLogoImageView.frame.size.width / 2
        
        cell.merchantLogoImageView.clipsToBounds = true
        cell.merchantLogoImageView.layer.borderColor = UIColor.whiteColor().CGColor
         cell.merchantLogoImageView.layer.borderWidth = 3
        
        //round card
        
        cell.cardBgImageView.layer.cornerRadius = cell.merchantLogoImageView.frame.size.width / 2
        
        cell.cardBgImageView.clipsToBounds = true
        cell.cardBgImageView.layer.borderColor = UIColor.whiteColor().CGColor
        cell.cardBgImageView.layer.borderWidth = 3
        
        
        
    
        
        
        if let logoImageURL = cards[indexPath.row].logo_image  as? String {
            
            if let image = imageCache.objectForKey(logoImageURL) as? UIImage {
                
                cell.merchantLogoImageView.image = image
            }else{
                
                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: logoImageURL)!, completionHandler: { (data, response, error) -> Void in
                    if error != nil {
                        print(error)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    
                    self.imageCache.setObject(image!, forKey: logoImageURL)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        
                        cell.merchantLogoImageView.image = image
                        
                    })
                    
                }).resume()
                
            }
            
            
        }
        
        let pointsAccumulated = cards[indexPath.row].points_accumulated as? String
        
        let points: Int = Int(pointsAccumulated!)!
        
        
        switch points {
        case 1:
            
             cell.stampOneImageView?.image = UIImage(named: "stamp_star")
            break
            
        case 2:
            
            cell.stampOneImageView?.image = UIImage(named: "stamp_star")
            cell.stampTwoImageView?.image = UIImage(named: "stamp_star")
            break
        case 3:
            
            cell.stampOneImageView?.image = UIImage(named: "stamp_star")
            cell.stampTwoImageView?.image = UIImage(named: "stamp_star")
            cell.stampThreeImageView?.image = UIImage(named: "stamp_star")
            break
            
        case 4:
            
            cell.stampOneImageView?.image = UIImage(named: "stamp_star")
            cell.stampTwoImageView?.image = UIImage(named: "stamp_star")
            cell.stampThreeImageView?.image = UIImage(named: "stamp_star")
            cell.stampFourImageView?.image = UIImage(named: "stamp_star")
            break
            
        case 5:
            
            cell.stampOneImageView?.image = UIImage(named: "stamp_star")
            cell.stampTwoImageView?.image = UIImage(named: "stamp_star")
            cell.stampThreeImageView?.image = UIImage(named: "stamp_star")
            cell.stampFourImageView?.image = UIImage(named: "stamp_star")
            cell.stampFiveImageView?.image = UIImage(named: "stamp_star")
            break
            
        case 6:
            
            cell.stampOneImageView?.image = UIImage(named: "stamp_star")
            cell.stampTwoImageView?.image = UIImage(named: "stamp_star")
            cell.stampThreeImageView?.image = UIImage(named: "stamp_star")
            cell.stampFourImageView?.image = UIImage(named: "stamp_star")
            cell.stampFiveImageView?.image = UIImage(named: "stamp_star")
             cell.stampSixImageView?.image = UIImage(named: "stamp_star")
            
            break
            
            
        case 7:
            
            cell.stampOneImageView?.image = UIImage(named: "stamp_star")
            cell.stampTwoImageView?.image = UIImage(named: "stamp_star")
            cell.stampThreeImageView?.image = UIImage(named: "stamp_star")
            cell.stampFourImageView?.image = UIImage(named: "stamp_star")
            cell.stampFiveImageView?.image = UIImage(named: "stamp_star")
            cell.stampSixImageView?.image = UIImage(named: "stamp_star")
            cell.stampSevenImageView?.image = UIImage(named: "stamp_star")
            
            break
            
        case 8:
            
            cell.stampOneImageView?.image = UIImage(named: "stamp_star")
            cell.stampTwoImageView?.image = UIImage(named: "stamp_star")
            cell.stampThreeImageView?.image = UIImage(named: "stamp_star")
            cell.stampFourImageView?.image = UIImage(named: "stamp_star")
            cell.stampFiveImageView?.image = UIImage(named: "stamp_star")
            cell.stampSixImageView?.image = UIImage(named: "stamp_star")
              cell.stampSevenImageView?.image = UIImage(named: "stamp_star")
            cell.stampEightImageView?.image = UIImage(named: "stamp_star")
            
            break
            
        case 9:
            
            cell.stampOneImageView?.image = UIImage(named: "stamp_star")
            cell.stampTwoImageView?.image = UIImage(named: "stamp_star")
            cell.stampThreeImageView?.image = UIImage(named: "stamp_star")
            cell.stampFourImageView?.image = UIImage(named: "stamp_star")
            cell.stampFiveImageView?.image = UIImage(named: "stamp_star")
            cell.stampSixImageView?.image = UIImage(named: "stamp_star")
               cell.stampSevenImageView?.image = UIImage(named: "stamp_star")
            cell.stampEightImageView?.image = UIImage(named: "stamp_star")
            cell.stampNineImageView?.image = UIImage(named: "stamp_star")
            
            break
            
        case 10:
            
            cell.stampOneImageView?.image = UIImage(named: "stamp_star")
            cell.stampTwoImageView?.image = UIImage(named: "stamp_star")
            cell.stampThreeImageView?.image = UIImage(named: "stamp_star")
            cell.stampFourImageView?.image = UIImage(named: "stamp_star")
            cell.stampFiveImageView?.image = UIImage(named: "stamp_star")
            cell.stampSixImageView?.image = UIImage(named: "stamp_star")
               cell.stampSevenImageView?.image = UIImage(named: "stamp_star")
            cell.stampEightImageView?.image = UIImage(named: "stamp_star")
            cell.stampNineImageView?.image = UIImage(named: "stamp_star")
             cell.stampTenImageView?.image = UIImage(named: "stamp_star")
            
            break
            
        default:
            break
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
    
    
    
    
    
    
    
    func getCards() {
        

        
        
         let cardLoadURL = "http://emmancipatemusemwa.com/CustomerLoyaltyAppPHPMySQL/SourceFiles/scripts/getCards.php?userId=\(userId!)";
        
        
        let request = NSURLRequest(URL: NSURL(string: cardLoadURL)!)
        
        
        let urlSession = NSURLSession.sharedSession()
        
        let task = urlSession.dataTaskWithRequest(request, completionHandler: {(data, response, error) -> Void in
            
          
          
            
            if let error = error {
                
                print(error)
                
                return
                
            }
            
            //Parsing
            
            
            
            if let data = data {
                
                
                
                self.cards = self.parseJsonData(data)
                
                
                
              
                
                
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    
                    self.tableView.reloadData();
                    
                    
                    
                })
                
                
                
            }
            
            
            
            
            
            
            
        })
        
        task.resume()
        
        
        
        
        
    }
    
    
    
    
    
    func parseJsonData(data: NSData) -> [Card] {
        
        
        
        do {
            
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary
            
            
          
          
            
            //Parse Json Data
            
            
            
            if let jsonCards = jsonResult?["cards"] as? [AnyObject] {
            
           
            
            
            for jsonCard in jsonCards {
                
                
                
                let card = Card()
                
               card.merchant_name = jsonCard["merchant_name"] as! String
                
                card.bg_image = jsonCard["bg_image"] as! String
               card.logo_image = jsonCard["logo_image"] as! String
            
                card.points_accumulated = jsonCard["points_accumulated"] as! String
                //card.expiry_date = jsonCard["expiry_date"] as! String
                //card.merchant_category = jsonCard["merchant_category"] as! String
               
                
                
                
                
                
                
                
                
                
                cards.append(card)
                
                
                
                
                
                
                
            }
            
            
            
            }else{
            
                
                    // Display an alert message
                    let userMessage = "You have not added any cards, please scan a QR code at our partner stores to add a card."
                    self.displayAlertMessage(userMessage)
                    
                
            
            }
        
        
        }catch {
            
            print(error)
            
            
            
            
            
        }
        
        
        
        return cards
        
        
        
        
        
    }
    
    
    //Send Data Via Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let identifier = segue.identifier{
            
            switch identifier {
            case "showCardDetails":
                let cardDetailVC = segue.destinationViewController as! CardDetailTableViewController
                
                
                let indexPath = tableView.indexPathForSelectedRow
                let dataToPass = cards[indexPath!.row]
                
                cardDetailVC.viaCardsSegue = dataToPass
                
                
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
