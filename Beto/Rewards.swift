//
//  Rewards.swift
//  Beto
//
//  Created by Jem on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation
import SpriteKit

class Rewards {
    
    let rows = 2
    let columns = 4
    
    private let layer = SKNode()
    
    var background: SKSpriteNode
    var container: SKSpriteNode
    var coin: SKSpriteNode
    var claimButton: ButtonNode
        
    init() {
        background = SKSpriteNode(color: .blackColor(), size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        background.alpha = 0.0
        
        container = SKSpriteNode(imageNamed: "coinUnlocked")
        container.size = CGSize(width: 304, height: 225)
        container.position = CGPoint(x: 0, y: ScreenSize.height)
        
        coin = SKSpriteNode(imageNamed: "coin\(BetValues[GameData.unlockedCoins])")
        coin.position = CGPoint(x:0, y: 20)
 
        claimButton = ButtonNode(defaultButtonImage: "claimButton", activeButtonImage: "claimButton_active")
        // DELETE: change position and action to correct code
        claimButton.position = CGPoint(x: 0, y: -80)
    }
    
    func createRewardsLayer() -> SKNode {
        let fadeIn = SKAction.fadeAlphaTo(0.6, duration: 0.3)
        background.runAction(fadeIn)
        
        let dropDown = SKAction.moveToY(0, duration: 0.3)
        let compress = SKAction.scaleXBy(1.02, y: 0.9, duration: 0.2)
        let actions = SKAction.sequence([dropDown, compress, compress.reversedAction()])
        container.runAction(actions)
        
        claimButton.action = close
        
        container.addChild(coin)
        container.addChild(claimButton)
        
        layer.addChild(background)
        layer.addChild(container)
        
        return layer
    }
    
    func close() {
        let wait = SKAction.waitForDuration(0.5)
        
        let exitScreen = SKAction.moveToY(ScreenSize.height, duration: 0.4)
        let vaultActions = SKAction.sequence([exitScreen, SKAction.removeFromParent()])
        container.runAction(vaultActions)
        
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.3)
        let backgroundActions = SKAction.sequence([fadeOut, SKAction.removeFromParent()])
        background.runAction(backgroundActions)
        
        let actions = SKAction.sequence([wait, SKAction.removeFromParent()])
        layer.runAction(actions)
    }
}