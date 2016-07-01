//
//  DropdownNode.swift
//  Beto
//
//  Created by Jem on 6/15/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class DropdownNode {
    private let layer: SKNode
    private var container: SKNode
    private let background: SKSpriteNode
    
    init(container: SKSpriteNode) {
        layer = SKNode()
        layer.setScale(Constant.ScaleFactor)
        
        self.container = container
        
        background = SKSpriteNode(color: .blackColor(), size: CGSize(width: ScreenSize.Width, height: ScreenSize.Height))
        background.alpha = 0.0
    }
    
    func createLayer() -> SKNode {
        // Run SKActions
        let fadeIn = SKAction.fadeAlphaTo(0.6, duration: 0.3)
        background.runAction(fadeIn)
        
        let dropDown = SKAction.moveToY(0, duration: 0.3)
        let compress = SKAction.scaleXBy(1.02, y: 0.9, duration: 0.2)
        let actions = SKAction.sequence([dropDown, compress, compress.reversedAction()])
        container.runAction(actions)
     
        // Designate positions
        container.position = CGPoint(x: 0, y: ScreenSize.Height)
        
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

