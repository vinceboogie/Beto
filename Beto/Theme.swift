//
//  Theme.swift
//  Beto
//
//  Created by Jem on 6/3/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

enum ThemePrice: Int {
    case Priceless = 99999
    case Basic = 5
    case Premium = 10
    case Legendary = 50
}

class Theme {
    let name: String
    let background: String
    let board: String

    var unlocked: Bool
    var price: Int
 
    // Initializer for the current theme
    init(themeName: String, unlocked: Bool) {
        name = themeName
        
        background = "\(name.lowercaseString)Background"
        board = "\(name.lowercaseString)Board"
        
        self.unlocked = unlocked
        price = ThemePrice.Priceless.rawValue
    }
    
    init(themeName: String) {
        name = themeName
        
        background = "\(name.lowercaseString)Background"
        board = "\(name.lowercaseString)Board"
        
        unlocked = GameData.unlockedThemes.contains(themeName)
        price = ThemePrice.Priceless.rawValue
    }
    
    func setPrice(price: ThemePrice) {
        self.price = price.rawValue
    }
    
    func purchase() {
        unlocked = true
        GameData.subtractStarCoins(price)
        GameData.addPurchasedTheme(name)
        GameData.save()
    }
}