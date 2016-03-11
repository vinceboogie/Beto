//
//  StartGameNode.swift
//  Beto
//
//  Created by Jem on 2/17/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation
import SpriteKit

class StartGameNode: ButtonNode {
    
    override init(defaultButtonImage: String, activeButtonImage: String) {
        super.init(defaultButtonImage: defaultButtonImage, activeButtonImage: activeButtonImage)
        
        let rotR = SKAction.rotateByAngle(0.15, duration: 0.2)
        let rotL = SKAction.rotateByAngle(-0.15, duration: 0.2)
        let pause = SKAction.rotateByAngle(0, duration: 1.0)
        let cycle = SKAction.sequence([pause, rotR, rotL, rotL, rotR])
        let wobble = SKAction.repeatActionForever(cycle)

        runAction(wobble, withKey: "wobble")
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
