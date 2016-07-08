//
//  Theme.swift
//  Beto
//
//  Created by Jem on 6/3/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

class Theme {
    let name: String
    let background: String
    let board: String
    let unlocked: Bool
    
    init(themeName: String, unlocked: Bool) {
        name = themeName
        
        background = "\(name.lowercaseString)Background"
        board = "\(name.lowercaseString)Board"
        
        self.unlocked = unlocked
    }
}