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
        
        // DELETE: Temporary
        if name == "Default" {
            board = "\(name.lowercaseString)Board"
        } else {
            board = "whiteBoard"
        }
        
        self.unlocked = unlocked
    }
}