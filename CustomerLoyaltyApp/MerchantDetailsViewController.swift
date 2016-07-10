//
//  MerchantDetailsViewController.swift
//  CustomerLoyaltyApp
//
//  Created by Emmancipate Musemwa on 07/07/2016.
//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.
//

import UIKit

class MerchantDetailsViewController: UIViewController {

    @IBOutlet weak var recieveLabel: UILabel!
    
  
    
    var viaSegue: Merchant?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //recieveLabel.text = viaSegue?.merchant_name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
