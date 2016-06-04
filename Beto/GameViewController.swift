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
        
        // Custom background contents for iPhone 5 (Screen size: 320 x 480)
        if UIScreen.mainScreen().bounds.height == 568 {
            gameScene.background.contents = UIImage(named: GameData.theme.background)
        } else {
            gameScene.background.contents = boardScene
        }
        
        // Configure the gestures
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        // Subtract wagers from GameData        
        GameData.subtractCoins(boardScene.board.getWagers())
    }
    
    func handlePan(gesture:UIPanGestureRecognizer) {
        let translationY = gesture.translationInView(self.view).y
        let translationX = gesture.translationInView(self.view).x
        
        if touchCount < 2 {
            if translationY < -100 {
                for node in gameScene.geometryNodes.cubesNode.childNodes {
                    node.physicsBody!.applyTorque(SCNVector4(1,1,1,(translationY/400-1)), impulse: true) // Perfect spin
                    node.physicsBody!.applyForce(SCNVector3(translationX/17,(-translationY/130)+9,(translationY/5)-11), impulse: true) //MIN (0,17,-31) MAX (0,21,-65)
                }
                
                touchCount += 1
            }
        } else if touchCount == 2 {
            gameScene.shouldCheckMovement = true
        }
    }
    
    func handleResolveGameplay() {
        GameData.incrementGamesPlayed()
        
        var winningColors: [Color] = []
        
        for node in gameScene.geometryNodes.cubesNode.childNodes {
            let winningColor = gameScene.getWinningColor(node)
            let didWin = boardScene.board.payout(winningColor)
            
            if didWin && !winningColors.contains(winningColor) {
                GameData.incrementWinCount(winningColor)
                winningColors.append(winningColor)
            }
            
            self.gameScene.animateCubeResult(node, didWin: didWin)
            
            delay(1.0) {}
        }
            
        boardScene.board.resolveWagers()
        boardScene.board.toggleReplayButton()
        
        GameData.save()
        
        delay(1.0) {
            self.dismissViewControllerAnimated(true, completion: self.boardScene.showUnlockedNodes)
        }
    }
    
    func delay(delay: Double, closure: ()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
}

