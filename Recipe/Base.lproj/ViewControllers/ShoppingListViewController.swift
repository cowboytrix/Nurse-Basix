//
//  ShoppingListViewController.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var ingredientsArray : Array<RecipeIngredient> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44

        if let ingredients = UserDefaults.standard.object(forKey: "shoppingList") as? Array<Data> {

            ingredientsArray =  (NSKeyedUnarchiver.unarchiveObject(with: ingredients.first!) as? Array<RecipeIngredient>)!
        }

        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "nav_shopping_list_reset"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ShoppingListViewController.reset)), UIBarButtonItem(image: UIImage(named: "nav_shopping_list_clear"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(ShoppingListViewController.clear))]
    }

    @objc func reset() {
        for ingredient in ingredientsArray {
            ingredient.checked = false
            print(ingredient.checked)
        }

        tableView.reloadData()
    }

    @objc func clear() {
        ingredientsArray = []

        UserDefaults.standard.set([NSKeyedArchiver.archivedData(withRootObject: ingredientsArray)], forKey: "shoppingList")
        UserDefaults.standard.synchronize()

        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UserDefaults.standard.set([NSKeyedArchiver.archivedData(withRootObject: ingredientsArray)], forKey: "shoppingList")
        UserDefaults.standard.synchronize()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredientsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let ingredient = ingredientsArray[indexPath.row]

        let text = "\(ingredient.quantity) \(ingredient.name)"

        if ingredient.checked {
            let attributes = [NSAttributedStringKey.strikethroughStyle: "1"]
            let attrText = NSAttributedString(string: text, attributes: attributes)
            cell.textLabel?.attributedText = attrText
        } else {
            let attributes = [NSAttributedStringKey.strikethroughStyle: "0"]
            let attrText = NSAttributedString(string:text, attributes: attributes)
            cell.textLabel?.attributedText = attrText
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ingredient = ingredientsArray[indexPath.row]
        ingredient.checked = !ingredient.checked
        tableView.beginUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.endUpdates()
    }
}
