//
//  CoinVault.swift
//  Beto
//
//  Created by Jem on 3/5/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class CoinVault: DropdownNode {
    var changeDenominationHandler: (() -> ())?
    
    init() {
        var coins = [Coin]()
        
        let vault = SKSpriteNode(imageNamed: "coinVault")
        vault.size = CGSize(width: 304, height: 174)
        
        let closeButton = ButtonNode(defaultButtonImage: "closeButton")
        closeButton.size = CGSize(width: 44, height: 45)
        
        for (index, betValue) in Constant.Denominations.enumerate() {
            let coin = Coin(value: betValue, unlocked: index <= GameData.coinsUnlocked) 
            coin.size = CGSize(width: 38, height: 39)
            
            coins.append(coin)
        }
        
        super.init(container: vault)
        
        // Designate positions
        vault.position = CGPoint(x: 0, y: ScreenSize.Height)
        closeButton.position = CGPoint(x: 140, y: 74)

        // Add actions
        closeButton.action = close
        
        // Add nodes
        vault.addChild(closeButton)
        
        for coin in coins {
            let coinHolder = SKSpriteNode(imageNamed: "coinHolder")
            coinHolder.size = CGSize(width: 42, height: 42)
            coinHolder.position = pointForPosition(coins.indexOf(coin)!)
            
            coin.coinSelectedHandler = handleCoinSelected
            coin.position = CGPoint(x: 1, y: -1)
            
            coinHolder.addChild(coin)
            vault.addChild(coinHolder)
        }
    }
    
    func handleCoinSelected(coin: Coin) {
        GameData.setDenomination(coin.value)
        GameData.save()
        
        changeDenominationHandler!()
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