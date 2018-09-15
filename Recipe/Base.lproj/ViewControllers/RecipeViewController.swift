//
//  RecipeViewController.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit
import GoogleMobileAds

class RecipeViewController: AdvertisedViewController, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIAlertViewDelegate {

    var recipe = Recipe()

    var imageName = ""
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var summaryImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var ingredientsImageView: UIImageView!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeLabel: UILabel!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var recipeBtn: UIButton!
    @IBOutlet weak var summaryButton: UIButton!
    
    var favorited = false;

    var selectedTab = 0;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = nil
        let favorites = UserDefaults.standard.array(forKey: "favorites") as! Array<Int>?
        let recipeID = recipe.recipeId

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_add_shopping_list"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(RecipeViewController.addToShoppingList(_:)))
        
       self.tableView.estimatedRowHeight = 44.0
        
        imageName = "fav"
        if let f = favorites {
            if f.index(of: recipeID) != nil {
                imageName = "fav_added"
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.selectedTab == 2 {
            recipeBtn.sendActions(for: .touchUpInside)
        } else if self.selectedTab == 0 {
                summaryButton.sendActions(for: .touchUpInside)
        }
        
        
        
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 1
        if selectedTab == 0 {
            rows += 1
        } else if selectedTab == 1 {
            rows += recipe.ingredients.count
        } else if selectedTab == 2 {
            rows += recipe.steps.count
        }

        return rows
    }

    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell: RecipeMainCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipeMainCell.self), for: indexPath) as! RecipeMainCell

//            if recipe.icons.count > 0 {
//                let icon = recipe.icons[0]
//                if RemoteXMLUrl.characters.count > 0 {
//                    cell.recipeImage.hnk_setImageFromURL(NSURL(string: icon)!)
//                } else {
//                    cell.recipeImage.image = UIImage(named: icon)
//                }
//            }

            cell.favoriteButton .setImage(UIImage(named: imageName), for: UIControlState())
            cell.titleLabel.text = recipe.name
            cell.countryLabel.text = recipe.summary.origin
            cell.prepLabel.text = recipe.summary.preparationTime
            cell.cookLabel.text = recipe.summary.cookingTime
            cell.mealLabel.text = recipe.summary.portions
            cell.caloriesLabel.text = recipe.summary.calories

            return cell
        }
        if selectedTab == 0 {
            let cell: RecipeSummaryCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipeSummaryCell.self), for: indexPath) as! RecipeSummaryCell

            cell.summaryLabel.text = recipe.summary.desc
            
            return cell

        } else if selectedTab == 1 {
            let cell: RecipeIngredientCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipeIngredientCell.self), for: indexPath) as! RecipeIngredientCell

            let ingredient = recipe.ingredients[indexPath.row - 1]
            
            let ingredientsString = ingredient.quantity + "\n" + ingredient.name as NSString
            
            let ingredientsAttributedString = NSMutableAttributedString(string: ingredientsString as String, attributes: [NSAttributedStringKey.font:  UIFont(name: "HelveticaNeue-Light", size: 17.0)!])
            
            ingredientsAttributedString.addAttribute(NSAttributedStringKey.font, value: UIFont(name: "HelveticaNeue-Medium", size: 17.0)!, range: ingredientsString.range(of: ingredient.quantity))
            
            cell.ingredientsLabel.attributedText = ingredientsAttributedString
            
            return cell
            
        } else if selectedTab == 2 {
            let step = recipe.steps[indexPath.row - 1]
            
            if step.stepImage.isEmpty && step.videoURL.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipeInstructionCell.self), for: indexPath) as! RecipeInstructionCell
                
                cell.titleLabel.text = step.name
                cell.bodyLabel.text = step.desc
                
                return cell
            }
            else if step.stepImage.isEmpty && !step.videoURL.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipeInstructionVideoCell.self), for: indexPath) as! RecipeInstructionVideoCell
                
                cell.titleLabel.text = step.name
                cell.bodyLabel.text = step.desc
                cell.videoView.loadVideoURL(URL(string: step.videoURL)!)
                
                return cell
            }
            else if !step.stepImage.isEmpty && step.videoURL.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipeInstructionImageCell.self), for: indexPath) as! RecipeInstructionImageCell
                
                cell.titleLabel.text = step.name
                cell.bodyLabel.text = step.desc
                
                if step.stepImage.hasPrefix("http") {
                    cell.stepImageView.hnk_setImageFromURL(URL(string: step.stepImage)!)
                } else {
                    cell.stepImageView.image = UIImage(named: step.stepImage)
                }
                
                return cell
            }
            else {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipeInstructionImageVideoCell.self), for: indexPath) as! RecipeInstructionImageVideoCell
                
                cell.titleLabel.text = step.name
                cell.bodyLabel.text = step.desc
               
                if step.stepImage.hasPrefix("http") {
                    cell.stepImageView.hnk_setImageFromURL(URL(string: step.stepImage)!)
                } else {
                    cell.stepImageView.image = UIImage(named: step.stepImage)
                }
                
                cell.videoView.loadVideoURL(URL(string: step.videoURL)!)
                
                return cell
            }
        }

        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecipeSummaryCell.self), for: indexPath)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 280
        }

        return UITableViewAutomaticDimension
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        // Set cell width to 100%
        return collectionView.frame.size
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipe.icons.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : RecipeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeCell", for: indexPath) as! RecipeCell

        if recipe.icons.count > 0 {
            let icon = recipe.icons[indexPath.row]
            if RemoteXMLUrl.characters.count > 0 {
                cell.imageView.hnk_setImageFromURL(URL(string: icon)!)
            } else {
                cell.imageView.image = UIImage(named: icon)
            }
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }


    @IBAction func summaryButtonTapped(_ sender: AnyObject) {
        summaryImageView.image = UIImage(named: "tab-bar-summary_active");
        ingredientsImageView.image = UIImage(named: "tab-bar-ingredients");
        recipeImageView.image = UIImage(named: "tab-bar-recipe");

        selectedTab = 0

        summaryLabel.textColor = UIColor(red: 86/255, green: 165/255, blue: 92/255, alpha: 1.0)
        ingredientsLabel.textColor = UIColor(red: 146/255, green: 146/255, blue: 146/266, alpha: 1.0)
        recipeLabel.textColor = UIColor(red: 146/255, green: 146/255, blue: 146/266, alpha: 1.0)

        tableView.reloadData()
    }

    @IBAction func ingredientsButtonTapped(_ sender: AnyObject) {
        summaryImageView.image = UIImage(named: "tab-bar-summary");
        ingredientsImageView.image = UIImage(named: "tab-bar-ingredients_active");
        recipeImageView.image = UIImage(named: "tab-bar-recipe");

        selectedTab = 1

        summaryLabel.textColor = UIColor(red: 146/255, green: 146/255, blue: 146/266, alpha: 1.0)
        ingredientsLabel.textColor = UIColor(red: 86/255, green: 165/255, blue: 92/255, alpha: 1.0)
        recipeLabel.textColor = UIColor(red: 146/255, green: 146/255, blue: 146/266, alpha: 1.0)

        tableView.reloadData()
    }

    @IBAction func recipeButtonTapped(_ sender: AnyObject) {
        summaryImageView.image = UIImage(named: "tab-bar-summary");
        ingredientsImageView.image = UIImage(named: "tab-bar-ingredients");
        recipeImageView.image = UIImage(named: "tab-bar-recipe_active");
        selectedTab = 2

        summaryLabel.textColor = UIColor(red: 146/255, green: 146/255, blue: 146/266, alpha: 1.0)
        ingredientsLabel.textColor = UIColor(red: 146/255, green: 146/255, blue: 146/266, alpha: 1.0)
        recipeLabel.textColor = UIColor(red: 86/255, green: 165/255, blue: 92/255, alpha: 1.0)
        
        tableView.reloadData()
    }

    @IBAction func favoriteButtonTapped(_ sender: AnyObject) {
        let recipeID = recipe.recipeId

        var favorites = UserDefaults.standard.array(forKey: "favorites") as! Array<Int>?

        imageName = "fav_added"
        if let f = favorites {
            if let i = f.index(of: recipeID) {
                imageName = "fav"
                favorites?.remove(at: i)
            } else {
                favorites?.append(recipeID)
            }
        } else {
            favorites = [recipeID]
        }

        self.tableView.reloadData()

        UserDefaults.standard.set(favorites, forKey: "favorites")
        UserDefaults.standard.synchronize()
    }

    @IBAction func shareRecipe(_ sender: AnyObject) {
        let activity = UIActivityViewController(activityItems: [recipe.name, AppStoreUrl], applicationActivities: nil)

        present(activity, animated: true, completion: nil)
    }

    override func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
        super.adViewDidReceiveAd(bannerView)
        collectionViewBottomConstraint.constant = bannerView.frame.height
    }
    
    override func adView(_ bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        super.adView(bannerView, didFailToReceiveAdWithError: error)
        collectionViewBottomConstraint.constant = 0
    }

    @IBAction func addToShoppingList(_ sender: AnyObject) {
        UIAlertView(title: "Do you want to add the ingredients into the Shopping List?", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "OK").show()
    }

    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 1 {

            if let ingredients = UserDefaults.standard.object(forKey: "shoppingList") as? Array<Data> {

                var ingredientsArray =  (NSKeyedUnarchiver.unarchiveObject(with: ingredients.first!) as? Array<RecipeIngredient>)!

                ingredientsArray = ingredientsArray + recipe.ingredients
                UserDefaults.standard.set([NSKeyedArchiver.archivedData(withRootObject: ingredientsArray)], forKey: "shoppingList")
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.set([NSKeyedArchiver.archivedData(withRootObject: recipe.ingredients)], forKey: "shoppingList")
                UserDefaults.standard.synchronize()
                print("ingredients")
            }

            print(UserDefaults.standard.object(forKey: "shoppingList")!)
        }
    }
}
