//
//  AdvertisedViewController.swift
//  Recipe
//
//  Copyright © 2015 dmbTEAM. All rights reserved.
//

import UIKit
import GoogleMobileAds
//import AdSupport

class AdvertisedViewController: UIViewController, GADBannerViewDelegate {
    
    lazy var adBannerView: GADBannerView = createBannerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adBannerView.delegate = self
        
        if EnableAds {
            loadAds()
        }
    }
    
    func createBannerView() -> GADBannerView {
        let bannerHeight = kGADAdSizeBanner.size.height
        let bannerAdSize = GADAdSizeFromCGSize(CGSize(width: self.view.bounds.width, height: bannerHeight))
        let bannerView = GADBannerView(adSize: bannerAdSize, origin: CGPoint(x: 0, y: self.view.frame.height - bannerHeight))
        bannerView.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        bannerView.isHidden = true
        self.view.addSubview(bannerView)
        return bannerView
    }
    
    func loadAds() {
        
        adBannerView.rootViewController = UIApplication.shared.delegate?.window??.rootViewController
        
        adBannerView.adUnitID = adMobAdUnitID
        adBannerView.isAutoloadEnabled = true
        adBannerView.delegate = self
    }
    
    
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.isHidden = false
    }
    
    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerView.isHidden = true
    }
}
