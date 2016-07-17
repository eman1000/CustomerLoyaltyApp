//

//  CardTableViewCell.swift

//  CustomerLoyaltyApp

//

//  Created by Emmancipate Musemwa on 12/07/2016.

//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.

//



import UIKit



class CardTableViewCell: UITableViewCell {
    
    
    
    
    @IBOutlet weak var cardBgImageView: UIImageView!
    
    @IBOutlet weak var merchantLogoImageView: UIImageView!
    
    @IBOutlet weak var merchantNameLabel: UILabel!
    
    //Number Views
    
    @IBOutlet weak var pointViewOne: UIView!
    
    @IBOutlet weak var pointViewTwo: UIView!
    
    @IBOutlet weak var pointViewThree: UIView!
    
    @IBOutlet weak var pointViewFour: UIView!
    
    @IBOutlet weak var pointViewFive: UIView!
    
    @IBOutlet weak var pointViewSix: UIView!
    
    @IBOutlet weak var pointViewSeven: UIView!
    
    @IBOutlet weak var pointViewEight: UIView!
    
    @IBOutlet weak var pointViewNine: UIView!
    
    @IBOutlet weak var pointViewTen: UIView!
    
    
    //Overlay image views
    @IBOutlet weak var stampOneImageView: UIImageView!
    @IBOutlet weak var stampTwoImageView: UIImageView!
    @IBOutlet weak var stampThreeImageView: UIImageView!
    @IBOutlet weak var stampFourImageView: UIImageView!
    @IBOutlet weak var stampFiveImageView: UIImageView!
    @IBOutlet weak var stampSixImageView: UIImageView!
    @IBOutlet weak var stampSevenImageView: UIImageView!
    @IBOutlet weak var stampEightImageView: UIImageView!
    @IBOutlet weak var stampNineImageView: UIImageView!
    @IBOutlet weak var stampTenImageView: UIImageView!
    
    
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
        
        
        
        //round card
        
        
        
        pointViewOne.layer.cornerRadius = pointViewOne.frame.size.width / 2
        
        
        
        pointViewOne.clipsToBounds = true
        
        pointViewOne.layer.borderColor = UIColor.blackColor().CGColor
        
        pointViewOne.layer.borderWidth = 3
        
        
        
        pointViewTwo.layer.cornerRadius = pointViewTwo.frame.size.width / 2
        
        
        
        pointViewTwo.clipsToBounds = true
        
        pointViewTwo.layer.borderColor = UIColor.blackColor().CGColor
        
        pointViewTwo.layer.borderWidth = 3
        
        
        
        pointViewThree.layer.cornerRadius = pointViewThree.frame.size.width / 2
        
        
        
        pointViewThree.clipsToBounds = true
        
        pointViewThree.layer.borderColor = UIColor.blackColor().CGColor
        
        pointViewThree.layer.borderWidth = 3
        
        
        
        
        
        pointViewFour.layer.cornerRadius = pointViewFour.frame.size.width / 2
        
        
        
        pointViewFour.clipsToBounds = true
        
        pointViewFour.layer.borderColor = UIColor.blackColor().CGColor
        
        pointViewFour.layer.borderWidth = 3
        
        
        
        pointViewFive.layer.cornerRadius = pointViewFive.frame.size.width / 2
        
        
        
        pointViewFive.clipsToBounds = true
        
        pointViewFive.layer.borderColor = UIColor.blackColor().CGColor
        
        pointViewFive.layer.borderWidth = 3
        
        
        
        
        
        pointViewSix.layer.cornerRadius = pointViewSix.frame.size.width / 2
        
        
        
        pointViewSix.clipsToBounds = true
        
        pointViewSix.layer.borderColor = UIColor.blackColor().CGColor
        
        pointViewSix.layer.borderWidth = 3
        
        
        
        
        
        pointViewSeven.layer.cornerRadius = pointViewSeven.frame.size.width / 2
        
        
        
        pointViewSeven.clipsToBounds = true
        
        pointViewSeven.layer.borderColor = UIColor.blackColor().CGColor
        
        pointViewSeven.layer.borderWidth = 3
        
        
        
        
        
        pointViewEight.layer.cornerRadius = pointViewEight.frame.size.width / 2
        
        
        
        pointViewEight.clipsToBounds = true
        
        pointViewEight.layer.borderColor = UIColor.blackColor().CGColor
        
        pointViewEight.layer.borderWidth = 3
        
        
        
        
        
        pointViewNine.layer.cornerRadius = pointViewNine.frame.size.width / 2
        
        
        
        pointViewNine.clipsToBounds = true
        
        pointViewNine.layer.borderColor = UIColor.blackColor().CGColor
        
        pointViewNine.layer.borderWidth = 3
        
        
        
        pointViewTen.layer.cornerRadius = pointViewTen.frame.size.width / 2
        
        
        
        pointViewTen.clipsToBounds = true
        
        pointViewTen.layer.borderColor = UIColor.blackColor().CGColor
        
        pointViewTen.layer.borderWidth = 3
        
        
        
        
        
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
        
        
        
        // Configure the view for the selected state
        
    }
    
    
    
}

