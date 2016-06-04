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

        let betoGreen = UIColor(red: 126/255, green: 211/255, blue: 33/255, alpha: 1)
        let rewardsLabel = SKLabelNode(text: "REWARDS")
        rewardsLabel.fontName = Constant.FontNameExtraBold
        rewardsLabel.fontColor = betoGreen
        rewardsLabel.fontSize = 14
        rewardsLabel.position = CGPoint(x: 0, y: 30)

        let rewardsShadow = rewardsLabel.createLabelShadow()
                
        // Add labels
        details.addChild(titleShadow)
        details.addChild(titleLabel)
        details.addChild(rewardsShadow)
        details.addChild(rewardsLabel)
        
        super.init(container: unlockedNode)
        
        // Assign actions
        claimButton.action = close

        // Designate positions
        unlockedNode.position = CGPoint(x: 0, y: ScreenSize.Height)
        claimButton.position = CGPoint(x: 0, y: -80)

        // Add nodes
        unlockedNode.addChild(details)
        unlockedNode.addChild(claimButton)
    }
}