//
//  Square.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

class Square: ButtonNode {
    var color: Color
    var wager: Int
    var selected: Bool
    var label: SKLabelNode
    var defaultButtonImage: String
    
    var placeBetHandler: ((Square) -> ())?
    
    init(color: Color) {
        self.color = color
        self.wager = 0
        self.selected = false
        self.defaultButtonImage = color.rawValue + "Square"
        
        
        label = SKLabelNode(fontNamed: Constant.FontNameCondensed)
        label.hidden = true
        label.horizontalAlignmentMode = .Center
        label.verticalAlignmentMode = .Center
        
        let activeButtonImage = defaultButtonImage + "_active"
        
        super.init(defaultButtonImage: defaultButtonImage, activeButtonImage: activeButtonImage)

        self.updateLabel()
        addChild(label)
        
        self.action = squarePressed
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func squarePressed() {
        placeBetHandler!(self)
    }
    
    func updateLabel() {
        let formattedWager = formatStringFromNumber(wager)

        if wager >= 1000000 && formattedWager.count > 5 {
            label.fontSize = 28
        } else {
            label.fontSize = 32
        }
        
        label.text = formattedWager
    }
    
    private func formatStringFromNumber(number: Int) -> String {
        if number >= 1000000 {
            let formatter = NSNumberFormatter()
            formatter.minimumFractionDigits = 0
            formatter.maximumFractionDigits = 2
            
            let newNumber: Double = floor(Double(number) / 10000) / 100.0
            let formattedNumber = formatter.stringFromNumber(newNumber)!
            
            return "\(formattedNumber)M"
        } else {
            return "\(number)"
        }
    }
}
