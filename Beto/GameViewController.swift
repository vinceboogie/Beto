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
    
    @IBOutlet weak var coinsLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var buyButton: UIButton!

    @IBAction func playButtonPressed(sender: AnyObject) {
        var winningSquares = [Square]()
        
        for _ in 0...2 {
            let row = Int(arc4random_uniform(2))
            let column = Int(arc4random_uniform(3))
            
            let square = board.squareAtColumn(column, row: row)
            winningSquares.append(square)
            
            print("\(square.color)")
            
            if square.wager > 0 {
                NSUserDefaults().coins += square.wager
                NSUserDefaults().highScore = NSUserDefaults().coins
                scene.animateWin(square)
                updateLabels()
            }
        }
        
        for row in 0..<Rows {
            for column in 0..<Columns {
                let square = board.squareAtColumn(column, row: row)
                
                if square.wager > 0 && !winningSquares.contains(square){
                    NSUserDefaults().coins -= square.wager
                    
                    scene.animateLost(square)
                    square.wager = 0
                }
            }
        }
        
    }
    
    @IBAction func clearButtonPressed(sender: AnyObject) {
        board.clearWagers()
        scene.animateClearBet(board, completion: {})
        updateLabels()
    }
    
    @IBAction func buyButtonPressed(sender: AnyObject) {
        // DELETE: Dummy function/button
        NSUserDefaults().coins += 20
        NSUserDefaults().highScore = NSUserDefaults().coins
        updateLabels()
    }
    
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
        scene.placeBetHandler = handlePlaceBet
        
        // Present the scene.
        skView.presentScene(scene)
        
        // DELETE: Need a way to change betValues
        NSUserDefaults().betValue = 1
    
        beginGame()
    }
    
    func beginGame() {
        let newGame = board.createGameBoard()
        scene.addSpritesForSquares(newGame)
        
        updateLabels()
    }
    
    func handlePlaceBet(bet: Bet) {
        if bet.betValue <= NSUserDefaults().coins {
            bet.placeBet()
            scene.animatePlaceBet(bet, completion: {})
            updateLabels()
        } else {
            scene.runAction(scene.lostSound)
        }
        
    }

    func updateLabels() {

        let coins = NSUserDefaults().coins - board.getWagers()
        
        coinsLabel.text = String(format: "%ld", coins)
        highscoreLabel.text = String(format: "%ld", NSUserDefaults().highScore)
    }
    
}
