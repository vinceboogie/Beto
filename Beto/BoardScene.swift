//
//  BoardScene.swift
//  Beto
//
//  Created by Jem on 4/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class BoardScene: SKScene {
    var board: Board!
    var gameHUD: GameHUD!
    var boardLayer: SKNode!
    var gameHUDLayer: SKNode!
    var dropdownQueue: [DropdownNode]!
    var bonusDisplayButton: SKSpriteNode!
    var bonusTimer: SKLabelNode!
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
                
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        GameData.unlockedCoinHandler = showUnlockedCoin
        GameData.unlockedLevelHandler = addToDropdownQueue
        
        dropdownQueue = []
        
        let background = SKSpriteNode(imageNamed: GameData.theme.background)
        background.size = self.frame.size
        
        board = Board(scene: self)
        boardLayer = board.createLayer()
        
        board.toggleReplayButton()
        
        gameHUD = GameHUD(scene: self)
        gameHUDLayer = gameHUD.createLayer()
        
        bonusDisplayButton = SKSpriteNode(imageNamed: "bonusPayoutIcon")
        bonusDisplayButton.size = CGSize(width: 39, height: 47)
        bonusDisplayButton.position = CGPoint(x: 30 - ScreenSize.Width/2, y: ScreenSize.Height/2 - 70)
        
        bonusTimer = SKLabelNode()
        bonusTimer.fontColor = UIColor.whiteColor()
        bonusTimer.fontName = Constant.FontName
        bonusTimer.fontSize = 18
        bonusTimer.horizontalAlignmentMode = .Left
        bonusTimer.position = CGPoint(x: 50 - ScreenSize.Width/2, y: ScreenSize.Height/2 - 80)
        
        if !Audio.musicMuted {
            runAction(SKAction.waitForDuration(0.5), completion: {
                self.addChild(Audio.backgroundMusic)
            })
        }
        
        addChild(background)
        addChild(gameHUDLayer)
        addChild(boardLayer)
        addChild(bonusDisplayButton)
        addChild(bonusTimer)
    }
    
    override func update(currentTime: NSTimeInterval) {
        let interval = Int(GameData.bonusTimeLeft())
        
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = interval / 3600
        
        if hours == 0 {
            bonusTimer.text = String(format: "%02d:%02d", minutes, seconds)
        } else {
            bonusTimer.text = String(format: "%2d:%02d:%02d", hours, minutes, seconds)
        }
    
        if GameData.bonusPayoutEnabled() {
            bonusDisplayButton.hidden = false
            bonusTimer.hidden = false
        } else {
            bonusDisplayButton.hidden = true
            bonusTimer.hidden = true
        }
    }    

    func addToDropdownQueue(achievement: Achievement) {
        let unlocked = UnlockedLevel(achievement: achievement)
        dropdownQueue.append(unlocked)
    }
        
    func showUnlockedCoin() {
        let container = SKSpriteNode(imageNamed: "rewardUnlocked")
        container.size = CGSize(width: 304, height: 225)
        container.position = CGPoint(x: 0, y: ScreenSize.Height)
        
        let details = SKNode()
        
        let titleLabel = SKLabelNode(text: "COIN UNLOCKED")
        titleLabel.fontName = Constant.FontNameExtraBold
        titleLabel.fontColor = UIColor.whiteColor()
        titleLabel.fontSize = 14
        titleLabel.position = CGPoint(x: 0, y: 50)
        
        let titleShadow = SKLabelNode(text: titleLabel.text)
        titleShadow.fontName = titleLabel.fontName
        titleShadow.fontColor = UIColor.darkGrayColor()
        titleShadow.fontSize = titleLabel.fontSize
        titleShadow.position = CGPoint(x: titleLabel.position.x + 1, y: titleLabel.position.y - 1)
        
        let descriptionLabel = SKLabelNode(text: "Now available in the Coin Vault")
        descriptionLabel.fontName = Constant.FontName
        descriptionLabel.fontColor = UIColor.darkGrayColor()
        descriptionLabel.fontSize = 10
        descriptionLabel.position = CGPoint(x: 0, y: 35)
        
        let coin = SKSpriteNode(imageNamed: "coin\(Constant.Denominations[GameData.coinsUnlocked])")
        coin.size = CGSize(width: 38, height: 39)
        coin.position = CGPoint(x: 0, y: 10)
        
        // Add progress bar
        let progressBar = SKSpriteNode(imageNamed: "progressBar")
        progressBar.size = CGSize(width: 120, height: 6)
        progressBar.position = CGPoint(x: 0, y: -20)
        
        var progress = 1.0
        
        // Don't show label and calculate progress on last coin
        if GameData.coinsUnlocked != 7 {
            let nextCoinLabel = SKLabelNode(text: "Next Coin unlocks at \(Constant.CoinUnlockedAt[GameData.coinsUnlocked]) coins")
            nextCoinLabel.fontName = Constant.FontName
            nextCoinLabel.fontColor = UIColor.darkGrayColor()
            nextCoinLabel.fontSize = 10
            nextCoinLabel.position = CGPoint(x: 0, y: -40)
            
            details.addChild(nextCoinLabel)
            
            progress = Double(GameData.highscore) / Double(Constant.CoinUnlockedAt[GameData.coinsUnlocked])
            
            if progress > 1.0 {
                progress = 1.0
            }
        }
        
        let width = 120 * progress
        let offsetX = (width - 119.5) / 2
        
        let currentProgress = SKSpriteNode(imageNamed: "currentProgress")
        currentProgress.size = CGSize(width: width, height: 6)
        currentProgress.position = CGPoint(x: offsetX, y: 0)
        
        // Claim button
        let claimButton = ButtonNode(defaultButtonImage: "claimButton", activeButtonImage: "claimButton_active")
        claimButton.size = CGSize(width: 110, height: 40)
        claimButton.position = CGPoint(x: 0, y: -80)
        
        // Add nodes
        details.addChild(titleShadow)
        details.addChild(titleLabel)
        details.addChild(descriptionLabel)
        details.addChild(coin)
        
        progressBar.addChild(currentProgress)
        details.addChild(progressBar)
        
        container.addChild(details)
        container.addChild(claimButton)
        
        let coinUnlocked = DropdownNode(container: container)
        
        claimButton.action = coinUnlocked.close
        
        addChild(coinUnlocked.createLayer())
    }
    
    func showUnlockedNodes() {
        if GameData.coins == 0 {            
            let container = SKSpriteNode(imageNamed: "goldenTicketBackground")
            container.size = CGSize(width: 304, height: 267)
            container.position = CGPoint(x: 0, y: ScreenSize.Height)
            
            let titleLabel = SKLabelNode(text: "WHO DOESN'T LOVE FREE STUFF")
            titleLabel.fontName = Constant.FontNameExtraBold
            titleLabel.fontColor = UIColor.whiteColor()
            titleLabel.fontSize = 14
            titleLabel.position = CGPoint(x: 0, y: 65)
            
            let titleShadow = titleLabel.createLabelShadow()
            
            container.addChild(titleShadow)
            container.addChild(titleLabel)
            
            let ticket = SKSpriteNode(imageNamed: "goldenTicket")
            container.addChild(ticket)
            
            // Claim button
            let claimButton = ButtonNode(defaultButtonImage: "claimButton", activeButtonImage: "claimButton_active")
            claimButton.size = CGSize(width: 110, height: 40)
            claimButton.position = CGPoint(x: 0, y: -100)
            
            // Add nodes
            container.addChild(claimButton)
            
            let goldenTicket = DropdownNode(container: container)

            claimButton.action = {
                goldenTicket.close()
                GameData.addCoins(100)
                
                // Update labels
                self.gameHUD.coinsLabel.text = "\(GameData.coins)"
                self.gameHUD.highscoreLabel.text = "\(GameData.highscore)"
            }
            
            addChild(goldenTicket.createLayer())
        }
        
        for node in dropdownQueue.reverse() {
            addChild(node.createLayer())
        }
        
        dropdownQueue = []
    }
    
    func presentGameScene() {
        self.view!.window!.rootViewController!.performSegueWithIdentifier("showGameScene", sender: self)
    }
    
    func presentMenuScene() {
        Audio.backgroundMusic.removeFromParent()
        
        let transition = SKTransition.flipVerticalWithDuration(0.4)
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .AspectFill
        
        view!.presentScene(menuScene, transition: transition)
    }
}

