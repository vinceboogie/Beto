//
//  GameViewController.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright (c) 2016 redgarage. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {
    var scene: GameScene!
    
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
        let sceneView = view as! SCNView
        
        scene = GameScene()
        
        sceneView.scene = scene
        sceneView.playing = true
        sceneView.backgroundColor = UIColor.blackColor()
        // DELETE: What is this?
        sceneView.antialiasingMode = SCNAntialiasingMode.Multisampling4X
        
        // Create and configure the scene.
        let overlayScene = OverlayScene(size: sceneView.bounds.size)
        sceneView.overlaySKScene = overlayScene
    }
}
