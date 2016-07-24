//
//  Reward.swift
//  Beto
//
//  Created by Jem on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

struct Reward {
    let bonusPayoutMinutes: Int
    let bonusDiceMinutes: Int
    let themesUnlocked: Int
    
    init(bonusPayoutMinutes: Int, bonusDiceMinutes: Int, themesUnlocked: Int) {
        self.bonusPayoutMinutes = bonusPayoutMinutes
        self.bonusDiceMinutes = bonusDiceMinutes
        self.themesUnlocked = themesUnlocked
    }
    
    init(bonusPayoutMinutes: Int, bonusDiceMinutes: Int) {
        self.bonusPayoutMinutes = bonusPayoutMinutes
        self.bonusDiceMinutes = bonusDiceMinutes
        themesUnlocked = 0
    }
    
    init(bonusPayoutMinutes: Int, themesUnlocked: Int) {
        self.bonusPayoutMinutes = bonusPayoutMinutes
        self.themesUnlocked = themesUnlocked
        bonusDiceMinutes = 0
    }
    
    init(bonusDiceMinutes: Int, themesUnlocked: Int) {
        self.bonusDiceMinutes = bonusDiceMinutes
        self.themesUnlocked = themesUnlocked
        bonusPayoutMinutes = 0
    }
    
    init(bonusPayoutMinutes: Int) {
        self.bonusPayoutMinutes = bonusPayoutMinutes
        bonusDiceMinutes = 0
        themesUnlocked = 0
    }
    
    init(bonusDiceMinutes: Int) {
        self.bonusDiceMinutes = bonusDiceMinutes
        bonusPayoutMinutes = 0
        themesUnlocked = 0
    }
    
    init(themesUnlocked: Int) {
        self.themesUnlocked = themesUnlocked
        bonusPayoutMinutes = 0
        bonusDiceMinutes = 0
    }
}