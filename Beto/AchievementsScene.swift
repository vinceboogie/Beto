//
//  AchievementsScene.swift
//  Beto
//
//  Created by Jem on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class AchievementsScene: SKScene {
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder) is not used in this app")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        // DELETE: Achievements Scene placeholder
        let background = ButtonNode(defaultButtonImage: "placeholder")
        background.size = self.frame.size
        background.action = presentGameScene
        
        addChild(background)
    }
    
    func presentGameScene() {
        let transition = SKTransition.flipVerticalWithDuration(0.4)
        let gameScene = OverlayScene(size: self.size)
        gameScene.scaleMode = .AspectFill
        
        view!.presentScene(gameScene, transition: transition)
        
    }
}
