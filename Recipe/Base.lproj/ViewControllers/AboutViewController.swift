//
//  AboutViewController.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit

class AboutViewController: AdvertisedViewController {

    @IBAction func facebookPressed(_ sender: UIButton) {
        let url = URL(string: FacebookUrl)
        UIApplication.shared.openURL(url!)
    }

    @IBAction func twitterButton(_ sender: UIButton) {
        let url = URL(string: TwitterUrl)
        UIApplication.shared.openURL(url!)
    }
}
