//
//  Category.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit

open class Category: NSObject {
    var name : NSString = ""
    var icon : NSString = ""
    var recipes : Array<Recipe> = []

    override open var description: String {
        return "name \(name) --- icon \(icon)"
    }
}
