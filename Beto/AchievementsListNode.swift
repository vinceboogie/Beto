//
//  AchievementsListNode.swift
//  Beto
//
//  Created by Jem on 4/8/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class AchievementsListNode: DropdownNode {
    private let container: SKSpriteNode
    private var currentPage: Int
    private var achievementNodes: [AchievementNode]

    init() {
        let closeButton = ButtonNode(defaultButtonImage: "closeButton")
        closeButton.size = CGSize(width: 44, height: 45)

        let previousButton = ButtonNode(defaultButtonImage: "previousButton")
        previousButton.size = CGSize(width: 34, height: 35)

        let nextButton = ButtonNode(defaultButtonImage: "nextButton")
        nextButton.size = CGSize(width: 34, height: 35)

        container = SKSpriteNode(imageNamed: "achievementsListBackground")
        container.size = CGSize(width: 303, height: 413)

        if UIScreen.mainScreen().bounds.height == 480 {
            container.setScale(0.84507042) // Custom scale for iPhone 4 (Screen size: 320 x 480)
        }

        achievementNodes = []
        currentPage = 0

        // Change to different pages
        for achievement in Achievements.list {
            let node = AchievementNode(achievement: achievement)

            achievementNodes.append(node)
        }
        
        super.init(container: container)
        
        // Assign actions
        closeButton.action = close
        previousButton.action = previousPage
        nextButton.action = nextPage
        
        // Designate positions
        closeButton.position = CGPoint(x: 140, y: 190)
        previousButton.position = CGPoint(x: -20, y: -180)
        nextButton.position = CGPoint(x: 20, y: -180)
        container.position = CGPoint(x: 0, y: ScreenSize.Height)
        
        // Show first 5 achievements
        for index in 0...4 {
            let position = index + (5 * currentPage)
            
            achievementNodes[position].position =  pointForIndex(index)
            container.addChild(achievementNodes[position])
        }
        
        // Add nodes
        container.addChild(closeButton)
        container.addChild(previousButton)
        container.addChild(nextButton)
    }

    func previousPage() {
        if currentPage > 0 {
           let newPage = currentPage - 1

            for index in 0...4 {
                let currentPosition = index + (5 * currentPage)

                achievementNodes[currentPosition].removeFromParent()

                let newPosition = index + (5 * newPage)
                achievementNodes[newPosition].position = pointForIndex(index)
                container.addChild(achievementNodes[newPosition])
            }

            currentPage = newPage
        }
    }

    func nextPage() {
        let lastPage = Achievements.list.count / 5 - 1

        if currentPage < lastPage {
            let newPage = currentPage + 1

            for index in 0...4 {
                let currentPosition = index + (5 * currentPage)

                achievementNodes[currentPosition].removeFromParent()

                let newPosition = index + (5 * newPage)
                achievementNodes[newPosition].position = pointForIndex(index)
                container.addChild(achievementNodes[newPosition])
            }
    
            currentPage = newPage
        }
    }

    func pointForIndex(index: Int) -> CGPoint {

        let offsetY = 121 - 60 * index

        return CGPoint(x: 0, y: offsetY)
    }
}