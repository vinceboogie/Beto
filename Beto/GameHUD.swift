//
//  GameHUD.swift
//  Beto
//
//  Created by Jem on 2/25/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class GameHUD {
    private let layer: SKNode
    private let scene: SKScene
    private let gameHUD: SKSpriteNode
    private let menuButton: ButtonNode
    private let coinsNode: ButtonNode
    private let highscoreNode: ButtonNode
    
    let coinsLabel: SKLabelNode
    let highscoreLabel: SKLabelNode
    
    init(scene: SKScene) {
        self.scene = scene
        
        layer = SKNode()
        layer.setScale(Constant.ScaleFactor)
        
        gameHUD = SKSpriteNode(imageNamed: "gameHUD")
        gameHUD.size = CGSize(width: 320, height: 38)
        
        menuButton = ButtonNode(defaultButtonImage: "menuButton", activeButtonImage: "menuButton_active")
        menuButton.size = CGSize(width: 60, height: 25)
        
        coinsNode = ButtonNode(defaultButtonImage: "buyCoinsButton")
        coinsNode.size = CGSize(width: 100, height: 25)
        
        coinsLabel = SKLabelNode(text: "\(GameData.coins)")
        coinsLabel.fontName = Constant.FontNameCondensed
        coinsLabel.fontSize = 14
        coinsLabel.horizontalAlignmentMode = .Center
        coinsLabel.verticalAlignmentMode = .Center
        
        highscoreNode = ButtonNode(defaultButtonImage: "highscoreButton")
        highscoreNode.size = CGSize(width: 100, height: 25)
        
        highscoreLabel = SKLabelNode(text: "\(GameData.highscore)")
        highscoreLabel.fontName = Constant.FontNameCondensed
        highscoreLabel.fontSize = 14
        highscoreLabel.horizontalAlignmentMode = .Center
        highscoreLabel.verticalAlignmentMode = .Center
    }

    func createLayer() -> SKNode {
        // Assign actions
        menuButton.action = presentMenuScene
        highscoreNode.action = displayAchievements
        coinsNode.action = displayStore
        
        // Designate positions
        var gameHUDPosition: CGFloat = 266.0
        let dynamicPosition = (ScreenSize.height - gameHUD.size.height) / 2
        
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
    
    func presentMenuScene() {
        let transition = SKTransition.flipVerticalWithDuration(0.4)
        let menuScene = MenuScene(size: scene.size)
        menuScene.scaleMode = .AspectFill
        
        scene.view!.presentScene(menuScene, transition: transition)
    }
    
    func displayStore() {
        let store = Store()
        let layer = store.createLayer()

        scene.addChild(layer)
        
        // DELETE: Placeholder for In-App Purchases
        GameData.coins += 20
        coinsLabel.text = "\(GameData.coins)"
        
        if GameData.coins > GameData.highscore {
            GameData.highscore = GameData.coins
            highscoreLabel.text = "\(GameData.highscore)"

            GameData.didUnlockCoin()
        }
        
        GameData.saveGameData()
    }
    
    func displayAchievements() {
        let achievements = Achievements()
        let layer = achievements.createLayer()
        
        scene.addChild(layer)
    }
}