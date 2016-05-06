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
    let rewards: [Int] // DELETE: For now it's coins
    var level: Int
    var progress: Double
    
    var calculateLevel: (() -> (Int))?
    var calculateProgress: (() -> (Double))?
    
    init(name: String, requirementValues: [Int], requirements: [String], rewards: [Int]) {
        self.name = name
        self.requirementValues = requirementValues
        self.requirements = requirements
        self.rewards = rewards
        
        level = 0
        progress = 0
    }
    
    func update() {
        var oldLevel = 0
        var newLevel = 0
        
        oldLevel = level
        level = calculateLevel!()
        newLevel = level
        
        if newLevel > oldLevel {
            // DELETE: Replace with pop up node
            // Check for possible multiple level jump
            print("Rewards unlocked: ")
        }
        
        progress = calculateProgress!()
    }
}