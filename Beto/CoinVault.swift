//
//  CoinVault.swift
//  Beto
//
//  Created by Jem on 3/5/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class CoinVault {
    private let layer: SKNode
    private var coins: [Coin]
    
    var background: SKSpriteNode
    var vault: SKSpriteNode
    var closeButton: ButtonNode
    
    var changeBetValueHandler: (() -> ())?
    
    init() {
        coins = []
        layer = SKNode()
        layer.setScale(Constant.ScaleFactor)
        
        background = SKSpriteNode(color: .blackColor(), size: CGSize(width: ScreenSize.width, height: ScreenSize.height))
        background.alpha = 0.0
        
        vault = SKSpriteNode(imageNamed: "coinVault")
        vault.size = CGSize(width: 304, height: 174)
        
        closeButton = ButtonNode(defaultButtonImage: "closeButton")
        closeButton.size = CGSize(width: 44, height: 45)
    
        for (index, betValue) in BetValues.enumerate() {
            let coin = Coin(value: betValue, unlocked: index <= GameData.unlockedCoins)
            coin.size = CGSize(width: 38, height: 39)
            
            coins.append(coin)
        }
    }

    func createLayer() -> SKNode {
        // Run SKActions
        let fadeIn = SKAction.fadeAlphaTo(0.6, duration: 0.3)
        background.runAction(fadeIn)
        
        let dropDown = SKAction.moveToY(0, duration: 0.3)
        let compress = SKAction.scaleXBy(1.02, y: 0.9, duration: 0.2)
        let actions = SKAction.sequence([dropDown, compress, compress.reversedAction()])
        vault.runAction(actions)
    
        // Assign actions
        closeButton.action = close
        
        // Designate positions
        vault.position = CGPoint(x: 0, y: ScreenSize.height)
        closeButton.position = CGPoint(x: 140, y: 74)

        // Add nodes
        vault.addChild(closeButton)
        
        // Add coins to coinVault
        for coin in coins {
            let coinHolder = SKSpriteNode(imageNamed: "coinHolder")
            coinHolder.size = CGSize(width: 42, height: 42)
            coinHolder.position = pointForPosition(coins.indexOf(coin)!)
            
            coin.coinSelectedHandler = handleCoinSelected
            coin.position = CGPoint(x: 1, y: -1)
            
            coinHolder.addChild(coin)
            vault.addChild(coinHolder)
        }
    
        layer.addChild(background)
        layer.addChild(vault)
        
        return layer
    }
    
    func close() {
        let wait = SKAction.waitForDuration(0.5)
        
        let exitScreen = SKAction.moveToY(ScreenSize.height, duration: 0.4)
        let vaultActions = SKAction.sequence([exitScreen, SKAction.removeFromParent()])
        vault.runAction(vaultActions)
        
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.3)
        let backgroundActions = SKAction.sequence([fadeOut, SKAction.removeFromParent()])
        background.runAction(backgroundActions)
        
        let actions = SKAction.sequence([wait, SKAction.removeFromParent()])
        layer.runAction(actions)
    }
    
    func handleCoinSelected(coin: Coin) {
        GameData.defaultBetValue = coin.value
        changeBetValueHandler!()
        close()
    }
        
    func pointForPosition(position: Int) -> CGPoint {
        var column = 0
        var row = 0
        
        // Position coins based on a 2x4 grid
        if position <= 3 {
            column = position
        } else  {
            row = 1
            column = position - 4
        }
        
        let squareMargin: CGFloat = 10
        let squareWithMargin = 40 + squareMargin
        
        let offsetX = (-squareWithMargin * 1.5) + (squareWithMargin * CGFloat(column))
        let offsetY = (squareWithMargin / 2) - (squareWithMargin * CGFloat(row)) - 10
        
        return CGPoint(x: offsetX, y: offsetY)
    }
}