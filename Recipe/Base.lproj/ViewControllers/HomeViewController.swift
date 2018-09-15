//
//  HomeViewController.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit
import GoogleMobileAds

let RECIPES_SEGUE_IDENTIFIER = "RecipesViewController"

class HomeViewController: AdvertisedViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIAlertViewDelegate {
    
    @IBOutlet weak var myBanner: GADBannerView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    
    var categories : Array<Category> = []
    var recipes : Array<Recipe> = []
    var regions : Array<String> = []
    var selectedCategoryRecipes : Array<Recipe> = []
    var categoryName = ""
    var leftMenu = LeftMenuViewController()
    var regionsViewController = RegionViewController()
    var favorites : Array<Recipe> = []
    var parser = XMLManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Request
        let request = GADRequest()
        request.testDevices = [kGADSimulatorID]
        
        //Set up ad
        myBanner.adUnitID = "ca-app-pub-5098641750965866/6022412989"
        
        myBanner.rootViewController = self
        myBanner.delegate = self
        
        myBanner.load(request)
        
        self.title = NSLocalizedString("Home", comment: "Home")
        self.setupCollectionView()
        
        loadXML()
        
        searchView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.hideLeftMenu(_:)), name: NSNotification.Name(rawValue: "DidSelectLeftMenu"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.hideRegions(_:)), name: NSNotification.Name(rawValue: "DidSelectRegion"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.reloadData), name: NSNotification.Name(rawValue: "categoriesDownloaded"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadRecipes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        searchField.resignFirstResponder()
        searchField.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func reloadData() {
        self.categories = parser.categories
        collectionView.reloadData()
    }
    
    func loadXML() {
        // Categories setup
        parser.parse() { error in
            
            if error != nil {
                var errorMessage = error?.localizedDescription
                
                if errorMessage == nil {
                    errorMessage = "Unknown error."
                }
                self.showAlertControllerWithMessage(errorMessage!)
                
            } else {
                self.categories = self.parser.categories
                self.loadRecipes()
                
                self.collectionView.reloadData()
            }
        }
    }
    
    func loadRecipes() {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async(execute: { () -> Void in
            
            self.favorites = []
            self.recipes = []
            
            for (_, value) in self.categories.enumerated() {
                self.recipes += value.recipes
            }
            
            let fav = UserDefaults.standard.array(forKey: "favorites") as! Array<Int>?
            
            if let f = fav {
                for (_, value) in self.recipes.enumerated() {
                    if f.index(of: value.recipeId) != nil {
                        self.favorites.append(value)
                    }
                }
            }
            
            for (_, value) in self.recipes.enumerated() {
                if (self.regions.index(of: value.summary.origin) == nil) {
                    self.regions.append(value.summary.origin)
                }
            }
        })
    }
    
    func showAlertControllerWithMessage(_ message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { action in
            self.presentedViewController?.dismiss(animated: true, completion:  nil)
            self.loadXML()
        }
        
        alertController.addAction(dismissAction)
        alertController.addAction(retryAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Collectoin View
    func setupCollectionView() {
        let flowLayout = HomeCollectionViewLayout()
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        
        collectionView.collectionViewLayout = flowLayout;
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewLayout.layoutAttributesForItem(at: indexPath)!.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HomeCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let category = categories[indexPath.row]
        cell.bgImage?.image = UIImage(named: category.icon as String)
        cell.nameLabel?.text = "  "+(category.name as String)
        cell.recipesCoujntLabel.text = String(category.recipes.count)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.row]
        self.selectedCategoryRecipes = category.recipes
        categoryName = category.name as String
        self.performSegue(withIdentifier: RECIPES_SEGUE_IDENTIFIER, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == RECIPES_SEGUE_IDENTIFIER {
            let vc = segue.destination as! RecipesViewController
            vc.recipes = self.selectedCategoryRecipes
            vc.categoryName = categoryName
        }
    }
    
    @IBAction func leftMenuTapped(_ sender: AnyObject) {
        
        let storyboard = self.storyboard!
        leftMenu = storyboard.instantiateViewController(withIdentifier: "LeftMenuID") as! LeftMenuViewController
        leftMenu.categories = categories
        self.view.window!.addSubview(leftMenu.view)
    }
    
    @IBAction func searchButtonTapped(_ sender: AnyObject) {
        searchView.isHidden = false
    }
    
    @objc func hideLeftMenu(_ notification: Notification) {
        leftMenu.view.removeFromSuperview()
        
        var info = notification.userInfo!
        let index = info["selectedRow"] as! Int
        
        if index >= 0 && index < categories.count {
            let category = categories[index]
            self.selectedCategoryRecipes = category.recipes
            categoryName = category.name as String
            self.performSegue(withIdentifier: RECIPES_SEGUE_IDENTIFIER, sender: self)
        } else if index == categories.count {
            self.selectedCategoryRecipes = favorites
            categoryName = "Favorites"
            self.performSegue(withIdentifier: RECIPES_SEGUE_IDENTIFIER, sender: self)
            
        } else if index == categories.count + 1 {
            self.performSegue(withIdentifier: "ShoppingList", sender: self)
        } else if index == categories.count + 2 {
            self.performSegue(withIdentifier: "AboutViewIdentifier", sender: self)
        }
    }
    
    @objc func hideRegions(_ notification: Notification) {
        regionsViewController.view.removeFromSuperview()
        
        if let info = notification.userInfo {
            let region = info["region"] as! String
            var searchRecipes : Array<Recipe> = []
            for (_, value) in recipes.enumerated() {
                if  value.summary.origin == region {
                    searchRecipes.append(value)
                }
            }
            
            self.selectedCategoryRecipes = searchRecipes
            categoryName = "Filter"
            self.performSegue(withIdentifier: RECIPES_SEGUE_IDENTIFIER, sender: self)
        }
    }
    
    @IBAction func search(_ sender: AnyObject) {
        var searchRecipes : Array<Recipe> = []
        for (_, value) in recipes.enumerated() {
            if  value.name.lowercased().range(of: searchField.text!.lowercased()) != nil {
                searchRecipes.append(value)
            }
        }
        
        self.selectedCategoryRecipes = searchRecipes
        categoryName = "Search"
        self.performSegue(withIdentifier: RECIPES_SEGUE_IDENTIFIER, sender: self)
    }
    
    @IBAction func filterButtonTapped(_ sender: AnyObject) {
        regionsViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegionViewControllerIdentifier") as! RegionViewController
        regionsViewController.regions = regions
        
        self.view.window!.addSubview(regionsViewController.view)
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
