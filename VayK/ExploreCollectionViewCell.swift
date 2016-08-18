//
//  ExploreCollectionViewCell.swift
//  VayK
//
//  Created by Hayne Park on 6/25/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import UIKit

class ExploreCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView:UIImageView!
    @IBOutlet var label:UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        label.text = nil
    }
}
