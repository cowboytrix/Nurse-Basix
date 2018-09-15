//
//  RecipeIngredient.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit

class RecipeIngredient: NSObject {
    var name : String = ""
    var quantity : String = ""
    var checked : Bool = false

    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        quantity = aDecoder.decodeObject(forKey: "quantity") as! String
        checked = aDecoder.decodeBool(forKey: "checked")
    }

    override init() {

        super.init()
    }

    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(quantity, forKey: "quantity")
        aCoder.encode(checked, forKey: "checked")
    }

    override var description: String {
        return "name \(name) --- icon \(quantity)"
    }
}
