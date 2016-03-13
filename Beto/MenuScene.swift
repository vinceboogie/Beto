//
//  MenuScene.swift
//  Beto
//
//  Created by Jem on 2/17/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    
    let placeBetSound = SKAction.playSoundFileNamed("Chomp.wav", waitForCompletion: false)
    let clearBetSound = SKAction.playSoundFileNamed("Scrape.wav", waitForCompletion: false)
    let winSound = SKAction.playSoundFileNamed("Ka-Ching.wav", waitForCompletion: false)
    let lostSound = SKAction.playSoundFileNamed("Error.wav", waitForCompletion: false)
    
    var startGameButton: StartGameNode?

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: "menuBackground")
        background.size = self.frame.size
        addChild(background)
        
  
        let startGameButton = StartGameNode(defaultButtonImage: "startGame", activeButtonImage: "startGame_active")
        startGameButton.size = CGSize(width: 86, height: 103)
        startGameButton.action = presentGameScene
        addChild(startGameButton)
        
    }
    
    func presentGameScene() {

        self.view!.window!.rootViewController!.performSegueWithIdentifier("showGameScene", sender: self)
    }
}

