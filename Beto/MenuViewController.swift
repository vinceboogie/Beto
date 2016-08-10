//
//  MenuViewController.swift
//  Beto
//
//  Created by Jem on 3/10/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit
import GoogleMobileAds

class MenuViewController: UIViewController, GADInterstitialDelegate {
    var scene: SKScene!
    var interstitialAd: GADInterstitial!

    @IBOutlet weak var bannerView: GADBannerView!
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        if GameData.gamesPlayed % 10 == 0 || GameData.coins == 0 { 
            showInterstitialAD()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = MenuScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        // Present the scene.
        skView.presentScene(scene)
        
        // DELETE: Use TEST Ads during dev and testing. Change to live only on launch
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        let test = GADRequest()
        test.testDevices = ["57738ac8abf9499b8b4df6e379d05c76"]
        bannerView.loadRequest(test)
        
        interstitialAd = reloadInterstitialAd()
    }
    
    func reloadInterstitialAd() -> GADInterstitial {
        // DELETE: Test only. Change unit ID to real one
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
//        request.testDevices = ["57738ac8abf9499b8b4df6e379d05c76"]
        interstitial.delegate = self
        interstitial.loadRequest(request)
        
        return interstitial
    }
    
    func interstitialDidDismissScreen(ad: GADInterstitial!) {
        self.interstitialAd = reloadInterstitialAd()
    }
    
    func showInterstitialAD() {
        if interstitialAd.isReady {
            self.interstitialAd.presentFromRootViewController(self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let boardScene = sender as? BoardScene {
            if segue.identifier == "showGameScene" {
                let destinationVC = segue.destinationViewController as! GameViewController
                destinationVC.boardScene = boardScene
            }
        }
    }
}
