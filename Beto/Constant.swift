//
//  Constant.swift
//  Beto
//
//  Created by Jem on 2/24/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

// Delete: Revisit Singleton Later
let GameData = GameDataManager()
let Audio = AudioManager()
let Achievements = AchievementsManager()

struct Constant {
    static let Denominations = [1, 5, 10, 50, 100, 1000, 10000, 100000]
    static let Margin: CGFloat = 10
    static let ScaleFactor: CGFloat = UIScreen.mainScreen().bounds.width / 320
    static let FontName = "Futura Medium"
    static let FontNameCondensed = "Futura Condensed Medium"
    static let FontNameExtraBold = "Futura-CondensedExtraBold"
}

struct ScreenSize {
    static let Size = UIScreen.mainScreen().bounds.size
    static let Width = UIScreen.mainScreen().bounds.width
    static let Height = UIScreen.mainScreen().bounds.height
}

enum Color: String {
    case Blue = "Blue", Red = "Red", Green = "Green", Yellow = "Yellow", Cyan = "Cyan", Purple = "Purple"
    
    static let allValues = [Blue, Red, Green, Yellow, Cyan, Purple]
}

