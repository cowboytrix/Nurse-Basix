//
//  LeftMenuViewController.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit

class LeftMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var categories : Array<Category> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LeftMenuViewController.tapOnBackground))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func tapOnBackground() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DidSelectLeftMenu"), object: nil, userInfo: ["selectedRow" : -1])
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count + 7
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LeftMenuCell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCellIdentifier", for: indexPath) as! LeftMenuCell

        cell.menuImageView.image = nil
        cell.menuTitleLabel.text = nil
        if indexPath.row < categories.count {
            cell.menuImageView.image = UIImage(named: "left_"+(categories[indexPath.row].icon as String))
            cell.menuTitleLabel.text = categories[indexPath.row].name as String
        } else if indexPath.row == categories.count {
            cell.menuImageView.image = UIImage(named: "left_fav")
            cell.menuTitleLabel.text = NSLocalizedString("LeftMenuFavsKey", comment: "String from Localizable.strings file")
        } else if indexPath.row == categories.count + 1 {
            cell.menuImageView.image = UIImage(named: "left_menu_shopping_list")
            cell.menuTitleLabel.text = NSLocalizedString("LeftMenuShoppingListKey", comment: "String from Localizable.strings file")
        } else if indexPath.row == categories.count + 2 {
            cell.menuImageView.image = UIImage(named: "left_about")
            cell.menuTitleLabel.text = NSLocalizedString("LeftMenuAboutKey", comment: "String from Localizable.strings file")
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > categories.count + 3 {
            return
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DidSelectLeftMenu"), object: nil, userInfo: ["selectedRow" : indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: self.view)
        if tableView.frame.contains(point) {
            return false
        }

        return true
    }
}
