//
//  Recipe.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit

open class Recipe: NSObject {
    var recipeId = 0
    var name = ""
    var icons = Array<String>()
    var summary = RecipeSummary()
    var ingredients = Array<RecipeIngredient>()
    var steps = Array<RecipeStep>()

    override open var description: String {
        return "name \(name) --- icons \(icons)"
    }
}
