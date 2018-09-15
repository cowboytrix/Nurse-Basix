//
//  RegionViewController.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit

class RegionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var regions : Array<String> = []
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegionViewController.tapOnBackground))
        tapGesture.delegate = self
        self.view.addGestureRecognizer(tapGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func tapOnBackground() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DidSelectRegion"), object: nil, userInfo:nil)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return regions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "OriginCell", for: indexPath) 

        cell.textLabel?.text = regions[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "DidSelectRegion"), object: nil, userInfo:["region": regions[indexPath.row]])
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let point = touch.location(in: self.view)
        if tableView.frame.contains(point) {
            return false
        }

        return true
    }
}
