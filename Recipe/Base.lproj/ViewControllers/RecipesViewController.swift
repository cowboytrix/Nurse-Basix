//
//  RecipesViewController.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit
import GoogleMobileAds

class RecipesViewController: AdvertisedViewController, UITableViewDataSource, UITableViewDelegate {

    internal var recipes : Array<Recipe> = []
    var categoryName = ""
    var selectedRecipe = Recipe()
    var selectedTab = 0
    fileprivate let RecipeListCellIdentifier = "RecipeListCellIdentifier"
    fileprivate let RecipeDetailsIdentifier = "RecipeDetailsIdentifier"
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = categoryName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count;
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecipesListCell = tableView.dequeueReusableCell(withIdentifier: RecipeListCellIdentifier, for: indexPath) as! RecipesListCell

        let recipe = recipes[indexPath.row];

        if recipe.icons.count > 0 {
            let icon = recipe.icons[0]
            if RemoteXMLUrl.characters.count > 0 {
                cell.recipeImageView.hnk_setImageFromURL(URL(string: icon)!)
            } else {
                cell.recipeImageView.image = UIImage(named: icon)
            }
        }


        cell.titleLabel.text = recipe.name;
        cell.countryLabel.text = recipe.summary.origin
        cell.preparationTimeLabel.text = recipe.summary.preparationTime
        cell.cookTimeLabel.text = recipe.summary.cookingTime
        cell.caloriesLabel.text = recipe.summary.calories
        cell.cookItButton.tag = indexPath.row
        
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipe = recipes[indexPath.row]
        self.selectedTab = 0
        self.performSegue(withIdentifier: RecipeDetailsIdentifier, sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! RecipeViewController
        vc.recipe = selectedRecipe
        vc.title = categoryName
        vc.selectedTab = self.selectedTab
    }

    @IBAction func openRecipe(_ sender: UIButton) {
        self.selectedTab = 2
        selectedRecipe = recipes[sender.tag]
        self.performSegue(withIdentifier: RecipeDetailsIdentifier, sender: self)
    }
    override func adViewDidReceiveAd(_ bannerView: GADBannerView!) {
        super.adViewDidReceiveAd(bannerView)
        collectionViewBottomConstraint.constant = bannerView.frame.height
    }
    
    override func adView(_ bannerView: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        super.adView(bannerView, didFailToReceiveAdWithError: error)
        collectionViewBottomConstraint.constant = 0
    }
}
