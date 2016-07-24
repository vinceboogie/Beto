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
    var bonusPayoutNode: SKSpriteNode!
    var bonusPayoutTimer: SKLabelNode!
    var bonusDiceNode: SKSpriteNode!
    var bonusDiceLabel: SKLabelNode!
    var bonusDiceLabelShadow: SKLabelNode!
    var bonusDiceTimer: SKLabelNode!
    
    private var shouldAddReward = false
    private var rewardType = -1
    
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
        
        bonusPayoutNode = SKSpriteNode(imageNamed: "bonusPayoutIcon")
        bonusPayoutNode.size = CGSize(width: 39, height: 47)
        bonusPayoutNode.position = CGPoint(x: 30 - ScreenSize.Width/2, y: ScreenSize.Height/2 - 70)
        
        bonusPayoutTimer = SKLabelNode()
        bonusPayoutTimer.fontName = Constant.FontName
        bonusPayoutTimer.fontSize = 14
        bonusPayoutTimer.horizontalAlignmentMode = .Center
        bonusPayoutTimer.position = CGPoint(x: 32 - ScreenSize.Width/2, y: ScreenSize.Height/2 - 110)
        
        bonusDiceNode = SKSpriteNode(imageNamed: "bonusDice")
        bonusDiceNode.size = CGSize(width: 48, height: 38)
        bonusDiceNode.position = CGPoint(x: ScreenSize.Width/2 - 30, y: ScreenSize.Height/2 - 70)
        
        bonusDiceLabel = SKLabelNode(text: "+\(GameData.bonusDice)")
        bonusDiceLabel.fontName = Constant.FontNameExtraBold
        bonusDiceLabel.fontSize = 24
        bonusDiceLabel.position = CGPoint(x: ScreenSize.Width/2 - 18, y: ScreenSize.Height/2 - 90)
        
        bonusDiceLabelShadow = bonusDiceLabel.createLabelShadow()
        
        bonusDiceTimer = SKLabelNode()
        bonusDiceTimer.fontName = Constant.FontName
        bonusDiceTimer.fontSize = 14
        bonusDiceTimer.horizontalAlignmentMode = .Center
        bonusDiceTimer.position = CGPoint(x: ScreenSize.Width/2 - 32, y: ScreenSize.Height/2 - 105)
    
        
        if !Audio.musicMuted {
            runAction(SKAction.waitForDuration(0.5), completion: {
                self.addChild(Audio.backgroundMusic)
            })
        }
    
        addChild(background)
        addChild(gameHUDLayer)
        addChild(boardLayer)
        addChild(bonusPayoutNode)
        addChild(bonusPayoutTimer)
        addChild(bonusDiceNode)
        addChild(bonusDiceLabelShadow)
        addChild(bonusDiceLabel)
        addChild(bonusDiceTimer)
    }
    
    override func update(currentTime: NSTimeInterval) {
        if GameData.bonusPayoutEnabled() {
            setTimerText(Int(GameData.bonusPayoutTimeLeft()), timer: bonusPayoutTimer)
            bonusPayoutNode.hidden = false
            bonusPayoutTimer.hidden = false
        } else {
            bonusPayoutNode.hidden = true
            bonusPayoutTimer.hidden = true
        }
        
        if GameData.bonusDiceEnabled() {
            setTimerText(Int(GameData.bonusDiceTimeLeft()), timer: bonusDiceTimer)
            bonusDiceNode.hidden = false
            bonusDiceLabel.hidden = false
            bonusDiceLabelShadow.hidden = false
            bonusDiceTimer.hidden = false
        } else {
            bonusDiceNode.hidden = true
            bonusDiceLabel.hidden = true
            bonusDiceLabelShadow.hidden = true
            bonusDiceTimer.hidden = true
        }
    }
    
    func setTimerText(interval: Int, timer: SKLabelNode) {
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = interval / 3600
        
        if hours > 0 {
            timer.text = String(format: "%2d:%02d:%02d", hours, minutes, seconds)
        } else if minutes > 0 {
            timer.text = String(format: "%2d:%02d", minutes, seconds)
        } else {
            timer.text = String(format: ":%02d", seconds)
        }
    }
    
    func resolveRandomReward() {
        // Increment Win Percentage by 0.33/0.67/1 based on number of colors selected
        
        let rand = Int(arc4random_uniform(300)) + 1
        
        if rand <= GameData.rewardChance {
            shouldAddReward = true
            rewardType = rand % 3
        } else {
            shouldAddReward = false
        }
        
        // DELETE
//        print("Reward Type: \(rewardType)")
//        print("My num: \(rand)")
//        print("Reward chance: \(GameData.rewardChance)")
//        let percentage = (Double(GameData.rewardChance) / 300.0) * 100
//        print("Reward %: \(percentage)")
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
        
        let titleShadow = titleLabel.createLabelShadow()
        
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
        if shouldAddReward {
            /*** Random Reward ***/
            let container = SKSpriteNode(imageNamed: "rewardUnlocked")
            container.size = CGSize(width: 304, height: 225)
            container.position = CGPoint(x: 0, y: ScreenSize.Height)
            
            let rewardsLabel = SKLabelNode(text: "BONUS REWARD")
            rewardsLabel.fontName = Constant.FontNameExtraBold
            rewardsLabel.fontColor = Constant.BetoGreen
            rewardsLabel.fontSize = 14
            rewardsLabel.position = CGPoint(x: 0, y: 30)
            
            let rewardsLabelShadow = rewardsLabel.createLabelShadow()
            
            let sprite = SKSpriteNode(imageNamed: "bonusDice")
            sprite.size = CGSize(width: 48, height: 38)
            
            // DELETE: Temp
            let text = "+\(rewardType + 1) min"
            
//            if self.rewardType == 0 {
//                text = "+1 dice / +1 min"
//            } else if self.rewardType == 1 {
//                text = "+1 min"
//            } else if self.rewardType == 2 {
//                text = "+2 min"
//            }
            
            let label = SKLabelNode(text: text)
            label.fontName = Constant.FontName
            label.fontColor = UIColor.darkGrayColor()
            label.fontSize = 14
            label.position = CGPoint(x: 45, y: -5)
            
            // Claim button
            let claimButton = ButtonNode(defaultButtonImage: "claimButton", activeButtonImage: "claimButton_active")
            claimButton.size = CGSize(width: 110, height: 40)
            claimButton.position = CGPoint(x: 0, y: -80)
            
            // Add nodes
            sprite.addChild(label)
            
            container.addChild(rewardsLabelShadow)
            container.addChild(rewardsLabel)
            container.addChild(sprite)
            container.addChild(claimButton)
            
            let randomReward = DropdownNode(container: container)
            
            claimButton.action = {
                randomReward.close()
                
                if self.rewardType == 0 {
                    GameData.addDice(1)
                    GameData.addBonusDiceTime(1)
                } else if self.rewardType == 1 {
                    GameData.addDice(1)
                    GameData.addBonusDiceTime(2)
                } else if self.rewardType == 2 {
                    GameData.addDice(1)
                    GameData.addBonusDiceTime(3)
                }
                
                self.bonusDiceLabel.text = "+\(GameData.bonusDice)"
                self.bonusDiceLabelShadow.text = "+\(GameData.bonusDice)"
            }
            
            addChild(randomReward.createLayer())
        }
        
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
                self.gameHUD.updateCoinsLabel(GameData.coins)
                self.gameHUD.updateHighscoreLabel(GameData.highscore)
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

