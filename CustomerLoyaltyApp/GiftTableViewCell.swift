//
//  GiftTableViewCell.swift
//  CustomerLoyaltyApp
//
//  Created by Emmancipate Musemwa on 06/08/2016.
//  Copyright © 2016 Emmancipate Musemwa. All rights reserved.
//

import UIKit

class GiftTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var merchantNameLabel: UILabel!
    
    @IBOutlet weak var giftImageView: UIImageView!
    
    @IBOutlet weak var giftNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
