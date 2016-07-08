//
//  Reward.swift
//  Beto
//
//  Created by Jem on 3/9/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import SpriteKit

struct Reward {
    let bonusPayoutHours: Int
    let themesUnlocked: Int
    
    init(bonusPayoutHours: Int, themesUnlocked: Int) {
        self.bonusPayoutHours = bonusPayoutHours
        self.themesUnlocked = themesUnlocked
    }
    
    init(bonusPayoutHours: Int) {
        self.bonusPayoutHours = bonusPayoutHours
        themesUnlocked = 0
    }
    
    init(themesUnlocked: Int) {
        self.themesUnlocked = themesUnlocked
        bonusPayoutHours = 0
    }
}