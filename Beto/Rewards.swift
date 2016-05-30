//
//  Rewards.swift
//  Beto
//
//  Created by Jem on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class Rewards {
    private let layer: SKNode
    private let background: SKSpriteNode
    private let container: SKSpriteNode
    private let coin: SKSpriteNode
    private let claimButton: ButtonNode
        
    init() {
        layer = SKNode()
        layer.setScale(Constant.ScaleFactor)
        
        background = SKSpriteNode(color: .blackColor(), size: CGSize(width: ScreenSize.Width, height: ScreenSize.Height))
        background.alpha = 0.0
        
        container = SKSpriteNode(imageNamed: "coinUnlocked")
        container.size = CGSize(width: 304, height: 225)
        
        coin = SKSpriteNode(imageNamed: "coin\(Constant.Denominations[GameData.coinsUnlocked])")
        coin.size = CGSize(width: 38, height: 39)
 
        claimButton = ButtonNode(defaultButtonImage: "claimButton")
        claimButton.size = CGSize(width: 110, height: 40)
    }
    
    func createLayer() -> SKNode {
        // Run SKActions
        let fadeIn = SKAction.fadeAlphaTo(0.6, duration: 0.3)
        background.runAction(fadeIn)
        
        let dropDown = SKAction.moveToY(0, duration: 0.3)
        let compress = SKAction.scaleXBy(1.02, y: 0.9, duration: 0.2)
        let actions = SKAction.sequence([dropDown, compress, compress.reversedAction()])
        container.runAction(actions)
        
        // Assign actions
        claimButton.action = close
        
        // Designate positions
        container.position = CGPoint(x: 0, y: ScreenSize.Height)
        coin.position = CGPoint(x: 0, y: 20)
        claimButton.position = CGPoint(x: 0, y: -80)
        
        // Add nodes
        container.addChild(coin)
        container.addChild(claimButton)
        
        layer.addChild(background)
        layer.addChild(container)
        
        return layer
    }
    
    func close() {
        let wait = SKAction.waitForDuration(0.5)
        
        let exitScreen = SKAction.moveToY(ScreenSize.Height, duration: 0.4)
        let vaultActions = SKAction.sequence([exitScreen, SKAction.removeFromParent()])
        container.runAction(vaultActions)
        
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.3)
        let backgroundActions = SKAction.sequence([fadeOut, SKAction.removeFromParent()])
        background.runAction(backgroundActions)
        
        let actions = SKAction.sequence([wait, SKAction.removeFromParent()])
        layer.runAction(actions)
    }
}