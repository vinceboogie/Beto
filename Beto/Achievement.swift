//
//  Achievement.swift
//  Beto
//
//  Created by Jem on 5/26/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

class Achievement {
    let name: String
    let requirementValues: [Int]
    let requirements: [String]
    let rewards: [Reward]
    var level: Int
    var progress: Double
    
    var calculateLevel: (() -> (Int))?
    var calculateProgress: (() -> (Double))?
    
    init(name: String, requirementValues: [Int], requirements: [String], rewards: [Reward]) {
        self.name = name
        self.requirementValues = requirementValues
        self.requirements = requirements
        self.rewards = rewards
        
        level = 0
        progress = 0
    }
    
    func update() {
        var oldLevel = 0
        
        oldLevel = level
        level = calculateLevel!()
        
        if level > oldLevel {
            GameData.unlockedLevelHandler!(self)
        }
        
        progress = calculateProgress!()
    }
}