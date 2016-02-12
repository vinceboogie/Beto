//
//  NSUserDefaults+Beto.swift
//  Beto
//
//  Created by Jem on 2/11/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

extension NSUserDefaults {
    var highScore: Int {
        get {
            return integerForKey("highScore")
        }
        
        set {
            guard newValue > highScore else {
                return
            }
            
            setInteger(newValue, forKey: "highScore")
        }
    }
    
    var coins: Int {
        get {
            return integerForKey("coins")
        }
        
        set {
            setInteger(newValue, forKey: "coins")
        }
    }
    
    var betValue: Int {
        get {
            return integerForKey("betValue")
        }
        
        set {
            setInteger(newValue, forKey: "betValue")
        }
    }
    
    var wagers: Int {
        get {
            return integerForKey("wagers")
        }
        
        set {
            setInteger(newValue, forKey: "wagers")
        }
    }
    
    // DELETE: reset sample
//    func resetHighScore() {
//        removeObjectForKey("highScore")
//    }
    
    func purchaseCoins() {
        coins += 20
    }
}