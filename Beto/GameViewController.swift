//
//  GameViewController.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright (c) 2016 redgarage. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

class GameViewController: UIViewController {
    
    var gameScene: GameScene! // SCNScene

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
        // Release any cached data, images, etc that aren't in use.
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        //Configure the scene
        gameScene = GameScene()

        //Configure the view
        let sceneView = self.view as! SCNView
        sceneView.scene = gameScene
        sceneView.delegate = gameScene
        sceneView.playing = true
        sceneView.backgroundColor = UIColor.blackColor()
        sceneView.antialiasingMode = SCNAntialiasingMode.Multisampling4X
        
        // Configure the overlay SKScene
        let overlayScene = OverlayScene(size: self.view.bounds.size)
        sceneView.overlaySKScene = overlayScene

        panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
        tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        tapRecognizer.addTarget(self, action: "sceneTapped:")
        
        overlayScene.board.playHandler = addGestures
    }
    
    func sceneTapped(recognizer: UITapGestureRecognizer) {
        let sceneView = self.view as! SCNView
        let location = recognizer.locationInView(sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        
        if hitResults.count > 0 {
            let result = hitResults[0]
            let node = result.node
            //            node.removeFromParentNode()
            node.physicsBody?.applyForce(SCNVector3(0,10,0), impulse: true)
            
            let channel = result.node.geometry!.firstMaterial!.diffuse.mappingChannel
            let texcoord = result.textureCoordinatesWithMappingChannel(channel)
            print(texcoord)
        }
    }
    
    func addGestures() {
        view.addGestureRecognizer(panGesture)
        view.addGestureRecognizer(tapGesture)
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
                
                touchCount+=1
            }
        } else if touchCount == 2 {
            // DELETE: test
            gameScene.shouldCheckMovement = true
        }
    }

    func handleTap(gesture:UITapGestureRecognizer) {
        touchCount = 0
        
        //TODO: PR#4 Currently does nothing, but will be used for game resets
        print("Screen tapped from game scene")
        gameScene.resetCubes()

//        for node in gameScene.rootNode.childNodes {
//            gameScene.getUpSide(node)
//        }
//        self.view.gestureRecognizers = []
        
    }
}