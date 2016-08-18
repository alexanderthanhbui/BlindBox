//
//  Restaurant.swift
//  VayK
//
//  Created by Hayne Park on 4/15/16.
//  Copyright © 2016 mgoldspink. All rights reserved.
//

import Foundation

class Restaurant {
    var name = ""
    var type = ""
    var location = ""
    var phoneNumber = ""
    var image = ""
    var isVisited = false
    init(name:String, type:String, location:String, phoneNumber:String, image:String, isVisited:Bool) {
    self.name = name
    self.type = type
    self.location = location
    self.phoneNumber = phoneNumber
    self.image = image
    self.isVisited = isVisited
    }
}
 