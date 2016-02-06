//
//  Square.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

enum SquareColor: Int, CustomStringConvertible {
    case Unknown = 0, Blue, Red, Green, Yellow, Cyan, Purple
    
    var squareColor: String {
        let squareColors = ["Blue", "Red", "Green", "Yellow", "Cyan", "Purple"]
        
        return squareColors[rawValue - 1] + "Square"
    }
    
    var description: String {
        return squareColor
    }
    
}

class Square : CustomStringConvertible {
    var bet = 0
    var column: Int
    var row: Int
    var squareColor: SquareColor
    var sprite: SKSpriteNode?
    var label: SKLabelNode?

    var description: String {
        return "type: \(squareColor) position: (\(column), \(row))"
    }
    
    init(column: Int, row: Int, squareColor: SquareColor) {
        self.column = column
        self.row = row
        self.squareColor = squareColor
    }
}
