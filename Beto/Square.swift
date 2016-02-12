//
//  Square.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

enum Color: Int {
    case Blue, Red, Green, Yellow, Cyan, Purple
    
    var color: String {
        let colors = ["Blue", "Red", "Green", "Yellow", "Cyan", "Purple"]
        
        return colors[rawValue]
    }
    
    var squareSpriteName: String {
        return color + "Square"
    }
    
}

class Square: Equatable {
    var wager = 0
    var column: Int
    var row: Int
    var color: Color
    var sprite: SKSpriteNode?

    init(column: Int, row: Int, color: Color) {
        self.column = column
        self.row = row
        self.color = color
    }
}

func ==(lhs: Square, rhs: Square) -> Bool {
    return lhs.row == rhs.row && lhs.column == rhs.column
}
