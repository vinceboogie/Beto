//
//  PowerUp.swift
//  Beto
//
//  Created by Jem on 8/11/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

enum PowerUpKey: String {
    case doubleDice
    case doublePayout
    case triplePayout
    case lifeline
    case rewind
    
    static let allValues = [doubleDice, doublePayout, triplePayout, lifeline, rewind]
}

class PowerUp: ButtonNode {
    private var count: Int
    
    var activatePowerUpHandler: ((PowerUp) -> ())?
    
    private let label: SKLabelNode
    private let labelShadow: SKLabelNode
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(name: String, count: Int) {
        self.count = count
        
        label = SKLabelNode(text: "\(count)")
        label.fontName = Constant.FontNameExtraBold
        label.fontSize = 24
        label.position = CGPoint(x: 10, y: -20)
        
        labelShadow = label.createLabelShadow()
        
        super.init(defaultButtonImage: name, activeButtonImage: name)

        self.name = name
        
        activeButton.color = UIColor.blackColor()
        activeButton.colorBlendFactor = 0.3
        
        addChild(labelShadow)
        addChild(label)
        
        self.action = buttonPressed
    }
    
    func buttonPressed() {
        // DELETE: Currently not subtracting count. Do we need to?
        if count > 0 {
            count -= 1
            activatePowerUpHandler!(self)            
        }
    }
}
