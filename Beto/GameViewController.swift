//
//  GameViewController.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright (c) 2016 redgarage. All rights reserved.
//

import SceneKit
import SpriteKit

class GameViewController: UIViewController {
    var gameScene: GameScene!
    var boardScene: BoardScene!
    var backButton: UIButton!

    var panGesture = UIPanGestureRecognizer.self()
    var tapGesture = UITapGestureRecognizer.self()
    var tapRecognizer = UITapGestureRecognizer.self()
    var touchCount = 0.0
        
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.AllButUpsideDown
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backButton = UIButton(frame: CGRect(x: 5, y: 7, width: 60, height: 25))
        backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        backButton.addTarget(self, action: #selector(buttonAction), forControlEvents: .TouchUpInside)
        self.view.addSubview(backButton)
        
        // Configure the scene
        gameScene = GameScene()
        gameScene.resolveGameplayHandler = { [unowned self] in self.handleResolveGameplay() }
        
        // Configure the view
        let sceneView = self.view as! SCNView
        sceneView.scene = gameScene
        sceneView.delegate = gameScene
        sceneView.playing = true
        sceneView.backgroundColor = UIColor.clearColor()
        sceneView.antialiasingMode = SCNAntialiasingMode.Multisampling4X
        
        // Configure the background
        gameScene.background.contents = UIImage(named: GameData.theme.background)
        
        // Configure the gestures
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
        
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
    }
    
    func handlePan(gesture:UIPanGestureRecognizer) {
        let translationY = gesture.translationInView(self.view).y
        let translationX = gesture.translationInView(self.view).x
        
        if touchCount < 2 {
            if translationY < -100 {
                for node in gameScene.geometryNodes.cubesNode.childNodes {
                    node.physicsBody!.applyTorque(SCNVector4(1,1,1,(translationY/400-1)), impulse: true) // Perfect spin
                    node.physicsBody!.applyForce(SCNVector3(translationX/17,(-translationY/130)+9,(translationY/5)-11), impulse: true) // MIN (0,17,-31) MAX (0,21,-65)
                }
                
                touchCount += 1
            }
        } else if touchCount == 2 {
            backButton.enabled = false
            gameScene.shouldCheckMovement = true
        }
    }
    
    func handleResolveGameplay() {
        // Subtract wagers from GameData
        GameData.subtractCoins(boardScene.board.getWagers())
        
        GameData.incrementGamesPlayed()
        
        var winningColors: [Color] = []
        var shouldCheckForReward = false
        
        for node in gameScene.geometryNodes.cubesNode.childNodes {
            let winningColor = gameScene.getWinningColor(node)
            let didWin = boardScene.board.payout(winningColor)
            
            if !shouldCheckForReward {
                shouldCheckForReward = didWin
            }
            
            if didWin && !winningColors.contains(winningColor) {
                GameData.incrementWinCount(winningColor)
                winningColors.append(winningColor)
            }
            
            self.gameScene.animateCubeResult(node, didWin: didWin)
            
            delay(1.0) {}
        }
            
        boardScene.board.resolveWagers()
        boardScene.board.toggleReplayButton()
        
        if shouldCheckForReward {
            let num = 4 - boardScene.board.colorsSelected
            
            GameData.incrementRewardChance(num)
            boardScene.resolveRandomReward()
        } else {
            GameData.resetRewardChance()
        }
        
        // Reset colorsSelected
        boardScene.board.colorsSelected = 0
        
        // DELETE: Temp. Subtract rewards
        if GameData.doublePayout > 0 {
            GameData.subtractPayoutReward(1)
        }
        
        if GameData.doubleDice > 0 {
            GameData.subtractDiceReward(1)
        }
        
        boardScene.updateRewards()
        
        GameData.save()
        
        delay(1.0) {
            self.dismissViewControllerAnimated(true, completion: self.boardScene.showUnlockedNodes)
        }
    }
        
    func buttonAction(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
}

