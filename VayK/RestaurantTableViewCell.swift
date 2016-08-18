//
//  RestaurantTableViewCell.swift
//  FoodPin
//
//  Created by Simon Ng on 15/8/15.
//  Copyright © 2015 AppCoda. All rights reserved.
//

import UIKit
import ParseUI

class RestaurantTableViewCell: PFTableViewCell {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var thumbnailImageView: PFImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
