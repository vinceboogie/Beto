//
//  AchievementsListNode.swift
//  Beto
//
//  Created by Jem on 4/8/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class AchievementsListNode {
    private let layer: SKNode
    private let background: SKSpriteNode
    private let achievementsNode: SKSpriteNode
    private let closeButton: ButtonNode
    private let previousButton: ButtonNode
    private let nextButton: ButtonNode
    
    private var currentPage: Int
    private var achievementNodes: [AchievementNode]
    
    init() {
        layer = SKNode()
        layer.setScale(Constant.ScaleFactor)
        
        background = SKSpriteNode(color: .blackColor(), size: CGSize(width: ScreenSize.Width, height: ScreenSize.Height))
        background.alpha = 0.0
        
        closeButton = ButtonNode(defaultButtonImage: "closeButton")
        closeButton.size = CGSize(width: 44, height: 45)
        
        previousButton = ButtonNode(defaultButtonImage: "previousButton")
        previousButton.size = CGSize(width: 34, height: 35)
        
        nextButton = ButtonNode(defaultButtonImage: "nextButton")
        nextButton.size = CGSize(width: 34, height: 35)
        
        achievementsNode = SKSpriteNode(imageNamed: "achievementsListBackground")
        achievementsNode.size = CGSize(width: 303, height: 413)
        
        achievementNodes = []
        currentPage = 0
        
        // Change to different pages
        for achievement in Achievements.list {
            let node = AchievementNode(achievement: achievement)
            
            achievementNodes.append(node)
        }
    }
    
    func createLayer() -> SKNode {
        // Run SKActions
        let fadeIn = SKAction.fadeAlphaTo(0.6, duration: 0.3)
        background.runAction(fadeIn)
        
        let dropDown = SKAction.moveToY(0, duration: 0.3)
        let compress = SKAction.scaleXBy(1.02, y: 0.9, duration: 0.2)
        let actions = SKAction.sequence([dropDown, compress, compress.reversedAction()])
        achievementsNode.runAction(actions)
        
        // Assign actions
        closeButton.action = close
        previousButton.action = previousPage
        nextButton.action = nextPage
        
        // Designate positions
        closeButton.position = CGPoint(x: 140, y: 190)
        previousButton.position = CGPoint(x: -25, y: -180)
        nextButton.position = CGPoint(x: 25, y: -180)
        achievementsNode.position = CGPoint(x: 0, y: ScreenSize.Height)
        
        
        // Show first 5 achievements
        for index in 0...4 {
            let position = index + (5 * currentPage)
            
            achievementNodes[position].position = pointForIndex(index)
            achievementsNode.addChild(achievementNodes[position])
        }
        
        // Add nodes
        achievementsNode.addChild(closeButton)
        achievementsNode.addChild(previousButton)
        achievementsNode.addChild(nextButton)
        
        layer.addChild(background)
        layer.addChild(achievementsNode)
        return layer
    }
    
    func close() {
        let wait = SKAction.waitForDuration(0.5)
        
        let exitScreen = SKAction.moveToY(ScreenSize.Height, duration: 0.4)
        let exitActions = SKAction.sequence([exitScreen, SKAction.removeFromParent()])
        achievementsNode.runAction(exitActions)
        closeButton.runAction(exitActions)
        
        let fadeOut = SKAction.fadeAlphaTo(0.0, duration: 0.3)
        let backgroundActions = SKAction.sequence([fadeOut, SKAction.removeFromParent()])
        background.runAction(backgroundActions)
        
        let actions = SKAction.sequence([wait, SKAction.removeFromParent()])
        layer.runAction(actions)
    }
    
    func previousPage() {
        if currentPage > 0 {
           let newPage = currentPage - 1
    
            for index in 0...4 {
                let currentPosition = index + (5 * currentPage)
                
                achievementNodes[currentPosition].removeFromParent()

                let newPosition = index + (5 * newPage)
                achievementNodes[newPosition].position = pointForIndex(index)
                achievementsNode.addChild(achievementNodes[newPosition])
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
                achievementsNode.addChild(achievementNodes[newPosition])
            }
            
            currentPage = newPage
        }
    }
    
    func pointForIndex(index: Int) -> CGPoint {
        
        let offsetY = 121 - 60 * index
        
        return CGPoint(x: 0, y: offsetY)
    }
}