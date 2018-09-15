//
//  XMLManager.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import Foundation

open class XMLManager {
    
    fileprivate(set) var loading: Bool = false
    open var categories : Array<Category> = []

    func parse(_ completionClosure: @escaping (_ error: NSError?) -> ()) {
        loading = true
        
        if RemoteXMLUrl.characters.count > 0 {
            let request = URLRequest(url: URL(string: RemoteXMLUrl)!)
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: {
                (data, response, error) in
                if error == nil {
                    let result = NSString(data: data!, encoding:
                        String.Encoding.utf8.rawValue)!
                    
                    self.parseXML(result as String)
                }
                
                DispatchQueue.main.async {
                    self.loading = false
                    completionClosure(error as NSError?)
                }
            }) 
            task.resume()
        } else {
            if let filePath = Bundle.main.path(forResource: "recipes_settings", ofType:"xml") {
                let data = try? Data(contentsOf: URL(fileURLWithPath: filePath))
                let string = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)

                self.parseXML(string as String?)
                DispatchQueue.main.async {
                    self.loading = false
                    completionClosure(nil)
                }
            }
        }
    }

    func parseXML(_ string: String?) {
        if let xmlString = string {
            let xml = SWXMLHash.parse(xmlString)
            
            for category in xml["Settings"]["Category"] {
                let cat = Category()
                
                if let name = category.element?.attribute(by: "name")?.text as NSString? {
                    cat.name = name
                }
                
                if let icon = category.element?.attribute(by: "icon")?.text as NSString? {
                    cat.icon = icon
                }
                
                self.categories.append(cat)
                
                for r in category["RecipeInfo"] {
                    let recipe = Recipe()
                    recipe.recipeId = Int((r.element?.attribute(by: "id")?.text)!)!
                    recipe.name = (r["RecipeTitle"][0].element?.text)!
                    cat.recipes.append(recipe)
                    
                    let sum = r["RecipeSummary"][0]
                    let summary = RecipeSummary()
                    summary.origin = (sum["RecipeSummaryOrigin"][0].element?.text!)!
                    summary.preparationTime = (sum["RecipeSummaryPreparationTime"][0].element?.text!)!
                    summary.cookingTime = (sum["RecipeSummaryCookingTime"][0].element?.text!)!
                    summary.portions = (sum["RecipeSummaryPortions"][0].element?.text!)!
                    summary.calories = (sum["RecipeSummaryCalories"][0].element?.text!)!
                    summary.desc = (sum["RecipeSummaryDescription"][0].element?.text!)!
                    recipe.summary = summary
                    
                    
                    for imageInfo in r["RecipePictureList"][0]["RecipePicture"] {
                        if let iconTitle = imageInfo.element?.text {
                            recipe.icons.append(iconTitle)
                        }
                    }
                    
                    
                    for ingredientInfo in r["RecipeIngredientsList"][0]["RecipeIngredient"] {
                        let ingredient = RecipeIngredient()
                        ingredient.name = (ingredientInfo["RecipeIngredientsName"][0].element?.text!)!
                        var quantity = ""
                        if let q = ingredientInfo["RecipeIngredientsQuantity"][0].element?.text {
                            quantity = q
                        }
                        
                        ingredient.quantity = quantity
                        recipe.ingredients.append(ingredient)
                    }
                    
                    for stepsInfo in r["RecipeStepsList"][0]["RecipeStep"] {
                        let step = RecipeStep()
                        step.name = (stepsInfo["RecipeStepName"][0].element?.text!)!
                        step.desc = (stepsInfo["RecipeStepDescription"][0].element?.text!)!
                        
                        if let stepVideoURL = stepsInfo["RecipeStepVideo"][0].element?.text {
                            step.videoURL = stepVideoURL
                        }
                        
                        if let stepImage = stepsInfo["RecipeStepImage"][0].element?.text {
                            step.stepImage = stepImage
                        }
                        
                        recipe.steps.append(step)
                    }
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "categoriesDownloaded"), object: nil, userInfo: nil)
                    
                }
            }
        }
    }
}
