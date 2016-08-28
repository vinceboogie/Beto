//
//  PowerUpVault.swift
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

class PowerUpVault: DropdownNode {
    var activatePowerUpHandler: ((PowerUp) -> ())?
    
    init(activePowerUp: String) {
        let vault = SKSpriteNode(imageNamed: "powerUpVault")
        vault.size = CGSize(width: 304, height: 214)
        
        let closeButton = ButtonNode(defaultButtonImage: "closeButton")
        closeButton.size = CGSize(width: 44, height: 45)
        
        super.init(container: vault)
        
        // Designate positions
        vault.position = CGPoint(x: 0, y: ScreenSize.Height)
        closeButton.position = CGPoint(x: 140, y: 94)
        
        // Add actions
        closeButton.action = close
        
        // Add nodes
        vault.addChild(closeButton)
        
        var position = 0

        for key in PowerUpKey.allValues {
            var count = GameData.powerUps[key.rawValue]!
            
            if key.rawValue == activePowerUp {
                count -= 1
            }
            
            let button = PowerUp(name: key.rawValue, count: count)
            button.position = pointForPosition(position)
            button.activatePowerUpHandler = handleActivatePowerUp
            
            vault.addChild(button)
            
            position += 1
        }
    }
    
    func handleActivatePowerUp(powerUp: PowerUp) {
        close()
        activatePowerUpHandler!(powerUp)
    }
    
    func pointForPosition(position: Int) -> CGPoint {
        var column = 0
        var row = 0
        
        // Position squares based on a 2x3 grid
        if position <= 2 {
            column = position
        } else  {
            row = 1
            column = position - 3
        }
        
        let xPosition: CGFloat = 80
        let yPosition: CGFloat = 50
    
        let offsetX = -xPosition + (xPosition * CGFloat(column))
        let offsetY = 30 - (yPosition * CGFloat(row))
        
        return CGPoint(x: offsetX, y: offsetY)
    }
}
