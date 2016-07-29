//
//  GameHUD.swift
//  Beto
//
//  Created by Jem on 2/25/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class GameHUD {
    private let scene: BoardScene
    private let layer: SKNode
    private let gameHUD: SKSpriteNode
    private let menuButton: ButtonNode
    private let coinsNode: ButtonNode
    private let highscoreNode: ButtonNode
    
    let coinsLabel: SKLabelNode
    let highscoreLabel: SKLabelNode
    
    init(scene: BoardScene) {
        self.scene = scene
        
        layer = SKNode()
        layer.setScale(Constant.ScaleFactor)
        
        gameHUD = SKSpriteNode(imageNamed: "headerBackground")
        gameHUD.size = CGSize(width: 320, height: 38)
        
        menuButton = ButtonNode(defaultButtonImage: "menuButton", activeButtonImage: "menuButton_active")
        menuButton.size = CGSize(width: 60, height: 25)
        
        coinsNode = ButtonNode(defaultButtonImage: "betoCoinsButton")
        coinsNode.size = CGSize(width: 100, height: 25)
        
        coinsLabel = SKLabelNode()
        coinsLabel.fontName = Constant.FontNameCondensed
        coinsLabel.fontSize = 14
        coinsLabel.horizontalAlignmentMode = .Center
        coinsLabel.verticalAlignmentMode = .Center
        
        highscoreNode = ButtonNode(defaultButtonImage: "highscoreButton")
        highscoreNode.size = CGSize(width: 100, height: 25)
        
        highscoreLabel = SKLabelNode()
        highscoreLabel.fontName = Constant.FontNameCondensed
        highscoreLabel.fontSize = 14
        highscoreLabel.horizontalAlignmentMode = .Center
        highscoreLabel.verticalAlignmentMode = .Center
        
        updateCoinsLabel(GameData.coins)
        updateHighscoreLabel(GameData.highscore)
    }
    
    func createLayer() -> SKNode {
        // Assign actions
        menuButton.action = scene.presentMenuScene
        highscoreNode.action = displayAchievements
        coinsNode.action = displayShop
        
        // Designate positions
        var gameHUDPosition: CGFloat = 266.0
        let dynamicPosition = (ScreenSize.Height - gameHUD.size.height) / 2
        
        // Custom position for iPhone 4 (Screen size: 320 x 480)
        if dynamicPosition < gameHUDPosition {
            gameHUDPosition = dynamicPosition
        }
        
        gameHUD.position = CGPoint(x: 0, y: gameHUDPosition)
        menuButton.position = CGPoint(x: (-gameHUD.size.width + menuButton.size.width + Constant.Margin) / 2 , y: 0)
        coinsNode.position = CGPoint(x: (gameHUD.size.width - coinsNode.size.width) / 2 - Constant.Margin, y: 0)
        highscoreNode.position = CGPoint(x: coinsNode.position.x - (highscoreNode.size.width + Constant.Margin), y: 0)
        
        // Add labels to corresponding nodes
        coinsNode.addChild(coinsLabel)
        highscoreNode.addChild(highscoreLabel)
        
        // Add nodes to gameHUD
        gameHUD.addChild(menuButton)
        gameHUD.addChild(highscoreNode)
        gameHUD.addChild(coinsNode)
        
        // Add gameHUD to the layer node
        layer.addChild(gameHUD)

        return layer
    }
    
    func updateCoinsLabel(coins: Int) {
        coinsLabel.text = formatStringFromNumber(coins)
    }
    
    func updateHighscoreLabel(highscore: Int) {
        highscoreLabel.text = formatStringFromNumber(highscore)
    }
    
    private func formatStringFromNumber(number: Int) -> String {
        if number >= 1000000 {
            let formatter = NSNumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            
            let newNumber: Double = floor(Double(number) / 10000) / 100.0
            let formattedNumber = formatter.stringFromNumber(newNumber)!
            
            return "\(formattedNumber)M"
        } else {
            return "\(number)"
        }
    }
    
    func displayShop() {
        let closeButton = ButtonNode(defaultButtonImage: "closeButton")
        closeButton.size = CGSize(width: 44, height: 45)
        closeButton.position = CGPoint(x: 140, y: 190)
        
        let container = SKSpriteNode(imageNamed: "shopBackground")
        container.size = CGSize(width: 304, height: 412)
        container.position = CGPoint(x: 0, y: ScreenSize.Height)

        let coinsBackground = SKSpriteNode(imageNamed: "coinsBackground")
        coinsBackground.size = CGSize(width: 276, height: 55)
        coinsBackground.position = CGPoint(x: 0, y: 124)
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.groupingSeparator = " "
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        let coins = numberFormatter.stringFromNumber(GameData.coins)
        
        let coinsLabel = SKLabelNode(text: coins)
        coinsLabel.fontName = Constant.FontNameCondensed
        coinsLabel.fontSize = 28
        coinsLabel.horizontalAlignmentMode = .Center
        coinsLabel.verticalAlignmentMode = .Center
        
        coinsBackground.addChild(coinsLabel)
        
        // DELETE: Add buy rewardsDice action, need to update labels after buying
        
        let buyBasic = ButtonNode(defaultButtonImage: "buyPlaceholder")
        buyBasic.size = CGSize(width: 137, height: 124)
        buyBasic.position = CGPoint(x: -69, y: 33)
        
        let buyDeluxe = ButtonNode(defaultButtonImage: "buyPlaceholder")
        buyDeluxe.size = CGSize(width: 137, height: 124)
        buyDeluxe.position = CGPoint(x: 69, y: 33)
        
        let buyPremium = ButtonNode(defaultButtonImage: "buyPlaceholder")
        buyPremium.size = CGSize(width: 137, height: 124)
        buyPremium.position = CGPoint(x: -69, y: -92)
        
        let buyPremiumPlus = ButtonNode(defaultButtonImage: "buyPlaceholder")
        buyPremiumPlus.size = CGSize(width: 137, height: 124)
        buyPremiumPlus.position = CGPoint(x: 69, y: -92)
        
        // Add nodes
        container.addChild(closeButton)
        container.addChild(coinsBackground)
        container.addChild(buyBasic)
        container.addChild(buyDeluxe)
        container.addChild(buyPremium)
        container.addChild(buyPremiumPlus)
        
        let shopNode = DropdownNode(container: container)
        closeButton.action = shopNode.close
        
        scene.addChild(shopNode.createLayer())
    }
    
    func displayAchievements() {
        let achievements = AchievementsListNode()
        let layer = achievements.createLayer()
        
        scene.addChild(layer)
    }
}