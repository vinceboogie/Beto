//
//  ThemesScene.swift
//  Beto
//
//  Created by Jem on 6/3/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class ThemesScene: SKScene {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        let layer = SKNode()
        
        if UIScreen.mainScreen().bounds.height == 480 {
            layer.setScale(0.84507042) // Custom scale for iPhone 4 (Screen size: 320 x 480)
        } else {
            layer.setScale(Constant.ScaleFactor)
        }
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let background = SKSpriteNode(imageNamed: GameData.theme.background)
        background.size = self.frame.size
        
        let titleLabel = SKLabelNode(text: "THEMES")
        titleLabel.fontName = Constant.FontNameCondensed
        titleLabel.fontColor = UIColor.whiteColor()
        titleLabel.fontSize = 24
        titleLabel.position = CGPoint(x: 0, y: 240)
        
        let titleShadow = SKLabelNode(text: titleLabel.text)
        titleShadow.fontName = titleLabel.fontName
        titleShadow.fontColor = UIColor.darkGrayColor()
        titleShadow.fontSize = titleLabel.fontSize
        titleShadow.position = CGPoint(x: titleLabel.position.x + 1, y: titleLabel.position.y - 1)
        
        let menuButton = ButtonNode(defaultButtonImage: "menuButton", activeButtonImage: "menuButton_active")
        menuButton.size = CGSize(width: 60, height: 25)
        menuButton.position = CGPoint(x: -120, y: 250) // DELETE: May have to tweak for iPhone4
        menuButton.action = presentMenuScene
        
        let container = SKSpriteNode(imageNamed: "themesContainer")
        container.size = CGSize(width: 300, height: 401)
        container.position = CGPoint(x: 0, y: 20)
        
        let themeManager = ThemeManager()
        var position = 0
        
        for theme in themeManager.themes {
            let sprite = ButtonNode(defaultButtonImage: "\(theme.name.lowercaseString)Preview")
            sprite.size = CGSize(width: 92, height: 92)
            sprite.position = pointForPosition(position, size: container.size)
            
            if theme.unlocked {
                sprite.action = {
                    GameData.changeTheme(theme)
                    GameData.save()
                    
                    background.texture = SKTexture(imageNamed: theme.background)
                }
            } else {
                let lockSprite = SKSpriteNode(imageNamed: "themeLocked")
                sprite.addChild(lockSprite)
            }
            
            container.addChild(sprite)
            position += 1
        }
        
        layer.addChild(titleShadow)
        layer.addChild(titleLabel)
        layer.addChild(container)
        layer.addChild(menuButton)
        
        addChild(background)
        addChild(layer)
    }
    
    func presentMenuScene() {
        let transition = SKTransition.flipVerticalWithDuration(0.4)
        let menuScene = MenuScene(size: self.size)
        menuScene.scaleMode = .AspectFill
        
        view!.presentScene(menuScene, transition: transition)
    }
    
    func pointForPosition(position: Int, size: CGSize) -> CGPoint {
        let row = position / 3
        let column = position % 3
    
        let previewWithMargin: CGFloat = 98
        
        let offsetX = -previewWithMargin + (previewWithMargin * CGFloat(column))
        let offsetY = (size.height - previewWithMargin + 10) / 2 - (previewWithMargin * CGFloat(row))
        
        return CGPoint(x: offsetX, y: -Constant.Margin + offsetY)
    }
}


