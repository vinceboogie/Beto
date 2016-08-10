//
//  UnlockedLevel.swift
//  Beto
//
//  Created by Jem on 5/27/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class UnlockedLevel: DropdownNode {
    
    init(achievement: Achievement) {        
        let unlockedNode = SKSpriteNode(imageNamed: "levelUnlocked")
        unlockedNode.size = CGSize(width: 304, height: 225)
        unlockedNode.position = CGPoint(x: 0, y: ScreenSize.Height)
        
        let claimButton = ButtonNode(defaultButtonImage: "claimButton", activeButtonImage: "claimButton_active")
        claimButton.size = CGSize(width: 110, height: 40)
        claimButton.position = CGPoint(x: 0, y: -80)

        let details = SKNode()

        var title = achievement.name
        
        if achievement.level == 1 {
            title += " I"
        } else if achievement.level == 2 {
            title += " II"
        } else if achievement.level == 3 {
            title += " III"
        }
        
        let titleLabel = SKLabelNode(text: title.uppercaseString)
        titleLabel.fontName = Constant.FontNameExtraBold
        titleLabel.fontColor = UIColor.whiteColor()
        titleLabel.fontSize = 14
        titleLabel.position = CGPoint(x: 0, y: 50)

        let titleShadow = titleLabel.createLabelShadow()

        let rewardsLabel = SKLabelNode(text: "REWARDS")
        rewardsLabel.fontName = Constant.FontNameExtraBold
        rewardsLabel.fontColor = Constant.BetoGreen
        rewardsLabel.fontSize = 14
        rewardsLabel.position = CGPoint(x: 0, y: 30)

        let rewardsLabelShadow = rewardsLabel.createLabelShadow()

        let rewardsNode = SKNode()
//        let rewards = achievement.rewards[achievement.level-1]
        
        let sprite = SKSpriteNode(imageNamed: "starCoin")

        let label = SKLabelNode(text: "x\(achievement.level)")
        label.fontName = Constant.FontName
        label.fontColor = UIColor.darkGrayColor()
        label.fontSize = 14
        label.position = CGPoint(x: 35, y: -5)
        
        sprite.addChild(label)
        rewardsNode.addChild(sprite)
        
        // DELETE: Might need this after the rewards rework
//        if rewards.themesUnlocked > 0 {
//            let sprite = SKSpriteNode(imageNamed: "themesButton")
//            sprite.size = CGSize(width: 44, height: 45)
//            
//            let label = SKLabelNode(text: "x\(rewards.themesUnlocked)")
//            label.fontName = Constant.FontName
//            label.fontColor = UIColor.darkGrayColor()
//            label.fontSize = 14
//            label.position = CGPoint(x: 35, y: -5)
//
//            if rewards.bonusPayoutMinutes > 0 {
//                sprite.position = CGPoint(x: -50, y: 0)
//            }
//            
//            sprite.addChild(label)
//            rewardsNode.addChild(sprite)
//        }
        
//        if rewards.bonusPayoutMinutes > 0 {
//            let sprite = SKSpriteNode(imageNamed: "bonusPayoutIcon")
//            sprite.size = CGSize(width: 39, height: 47)
//            
//            var text = "+\(rewards.bonusPayoutMinutes)min"
//            
//            if rewards.bonusPayoutMinutes > 1 {
//                text += "s"
//            }
//            
//            let label = SKLabelNode(text: text)
//            label.fontName = Constant.FontName
//            label.fontColor = UIColor.darkGrayColor()
//            label.fontSize = 14
//            label.position = CGPoint(x: 40, y: -5)
//            
//            if rewards.themesUnlocked > 0 {
//                sprite.position = CGPoint(x: 30, y: 0)
//            }
//
//            sprite.addChild(label)
//            rewardsNode.addChild(sprite)
//        }
        
        // Add labels
        details.addChild(titleShadow)
        details.addChild(titleLabel)
        details.addChild(rewardsLabelShadow)
        details.addChild(rewardsLabel)
        details.addChild(rewardsNode)
        
        super.init(container: unlockedNode)
        
        // Assign actions
        claimButton.action = {
            GameData.addStarCoins(achievement.level)
            GameData.save()
            self.close()
        }

        // Designate positions
        unlockedNode.position = CGPoint(x: 0, y: ScreenSize.Height)
        claimButton.position = CGPoint(x: 0, y: -80)

        // Add nodes
        unlockedNode.addChild(details)
        unlockedNode.addChild(claimButton)
    }
}