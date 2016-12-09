//
//  Helpers.swift
//  VayK
//
//  Created by Hayne Park on 11/28/16.
//  Copyright © 2016 Alexander Bui. All rights reserved.
//

import UIKit

func generateRandomData() -> [[UIColor]] {
    let numberOfRows = 2
    let numberOfItemsPerRow = 3

    return (0..<numberOfRows).map { _ in
        return (0..<numberOfItemsPerRow).map { _ in UIColor.randomColor() }
    }
}

extension UIColor {
    class func randomColor() -> UIColor {

        let hue = CGFloat(arc4random() % 100) / 100
        let saturation = CGFloat(arc4random() % 100) / 100
        let brightness = CGFloat(arc4random() % 100) / 100

        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
    }
}
