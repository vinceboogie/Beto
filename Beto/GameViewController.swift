//
//  GameViewController.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright (c) 2016 redgarage. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var scene: GameScene!
    var board: Board!
    
    var coins = 20
    var highscore = 234034
    
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
//        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
//            return .AllButUpsideDown
//        } else {
//            return .All
//        }
        
        return UIInterfaceOrientationMask.AllButUpsideDown
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = view as! SKView
        skView.multipleTouchEnabled = false
        
        // Create and configure the scene.
        scene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .AspectFill
        
        board = Board()
        scene.board = board
        
        // Present the scene.
        skView.presentScene(scene)
        
        beginGame()
    }
    
    func beginGame() {
        updateLabels()
        
        let newGame = board.createGameBoard()
        scene.addSpritesForSquares(newGame)
    }
    
    func updateLabels() {
        coinsLabel.text = String(format: "%ld", coins)
        highscoreLabel.text = String(format: "%ld", highscore)
    }
}
