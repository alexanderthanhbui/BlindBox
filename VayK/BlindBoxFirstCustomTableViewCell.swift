//
//  BlindBoxFirstCustomTableViewCell.swift
//  VayK
//
//  Created by Hayne Park on 6/30/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit

class BlindBoxFirstCustomTableViewCell: UITableViewCell {
    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var titleLabel:UILabel!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

