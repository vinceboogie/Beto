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
        gameScene.cubeRestHandler = handleCubeRest
        gameScene.endGameplayHandler = handleEndGameplay
        
        // Configure the view
        let sceneView = self.view as! SCNView
        sceneView.scene = gameScene
        sceneView.delegate = gameScene
        sceneView.playing = true
        sceneView.backgroundColor = UIColor.clearColor()
        sceneView.antialiasingMode = SCNAntialiasingMode.Multisampling4X
        
        gameScene.background.contents = boardScene
        
        // Configure the gestures
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(GameViewController.handlePan(_:)))
        view.addGestureRecognizer(panGesture)

        tapGesture = UITapGestureRecognizer(target: self, action: #selector(GameViewController.handleTap(_:)))
        view.addGestureRecognizer(tapGesture)

        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        
        // Subtract wagers from GameData
        GameData.coins -= boardScene.board.getWagers()
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

    func handleCubeRest(winningColor: Color) {
        dispatch_async(dispatch_get_main_queue()) {
            self.boardScene.board.payout(winningColor)
        }
    }
    
    func handleEndGameplay() {
        dispatch_async(dispatch_get_main_queue()) {
            self.boardScene.board.resolveWagers()
            self.boardScene.board.toggleReplayButton()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
 
    func handleTap(gesture:UITapGestureRecognizer) {
        //TODO: Cancel gesture
    }
}