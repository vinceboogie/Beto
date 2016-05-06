//
//  GameDataManager.swift
//  Beto
//
//  Created by Jem on 2/23/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

class GameDataManager {
    private(set) var coins: Int
    private(set) var highscore: Int
    private(set) var betDenomination: Int
    private(set) var coinsUnlocked: Int
    private(set) var soundMuted: Bool
    private(set) var musicMuted: Bool
    
    private(set) var gamesPlayed: Int
    private(set) var redWinCount: Int
    private(set) var blueWinCount: Int
    private(set) var greenWinCount: Int
    private(set) var yellowWinCount: Int
    private(set) var cyanWinCount: Int
    private(set) var purpleWinCount: Int
    private(set) var highestWager: Int
    
    var showUnlockedCoinHandler: (() -> ())?
    
    // keys
    private let coinsKey = "coins"
    private let highscoreKey = "highscore"
    private let betDenominationKey = "betDenomination"
    private let coinsUnlockedKey = "coinsUnlocked"
    private let soundMutedKey = "soundMuted"
    private let musicMutedKey = "musicMuted"
    private let gamesPlayedKey = "gamesPlayed"
    private let redWinCountKey = "redWinCount"
    private let blueWinCountKey = "blueWinCount"
    private let greenWinCountKey = "greenWinCount"
    private let yellowWinCountKey = "yellowWinCount"
    private let cyanWinCountKey = "cyanWinCount"
    private let purpleWinCountKey = "purpleWinCount"
    private let highestWagerKey = "highestWager"
    
    init() {        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
        let fileManager = NSFileManager.defaultManager()
        
        // check if file exists
        if(!fileManager.fileExistsAtPath(path)) {
            // If it doesn't, copy it from the default file in the bundle
            if let bundlePath = NSBundle.mainBundle().pathForResource("GameData", ofType: "plist") {
                do {
                    try fileManager.copyItemAtPath(bundlePath, toPath: path)
                } catch {
                    print("Error copying file")
                }
            } else {
                print("GameData.plist not found. Please make sure it is part of the bundle.")
            }
        }
        
        let myDict = NSDictionary(contentsOfFile: path)
        
        if let dict = myDict {
            // load values
            coins = dict.objectForKey(coinsKey) as! Int
            highscore = dict.objectForKey(highscoreKey) as! Int
            betDenomination = dict.objectForKey(betDenominationKey) as! Int
            coinsUnlocked = dict.objectForKey(coinsUnlockedKey) as! Int
            soundMuted = dict.objectForKey(soundMutedKey) as! Bool
            musicMuted = dict.objectForKey(musicMutedKey) as! Bool
            
            gamesPlayed = dict.objectForKey(gamesPlayedKey) as! Int
            redWinCount = dict.objectForKey(redWinCountKey) as! Int
            blueWinCount = dict.objectForKey(blueWinCountKey) as! Int
            greenWinCount = dict.objectForKey(greenWinCountKey) as! Int
            yellowWinCount = dict.objectForKey(yellowWinCountKey) as! Int
            cyanWinCount = dict.objectForKey(cyanWinCountKey) as! Int
            purpleWinCount = dict.objectForKey(purpleWinCountKey) as! Int
            highestWager = dict.objectForKey(highestWagerKey) as! Int

        } else {
            // set failsafe default values
            coins = 50
            highscore = 50
            betDenomination = 1
            coinsUnlocked = 0
            soundMuted = true
            musicMuted = true
            
            gamesPlayed = 0
            redWinCount = 0
            blueWinCount = 0
            greenWinCount = 0
            yellowWinCount = 0
            cyanWinCount = 0
            purpleWinCount = 0
            highestWager = 0
        }
    }
    
    func save() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        
        // save values
        dict.setObject(coins, forKey: coinsKey)
        dict.setObject(highscore, forKey: highscoreKey)
        dict.setObject(betDenomination, forKey: betDenominationKey)
        dict.setObject(coinsUnlocked, forKey: coinsUnlockedKey)
        dict.setObject(soundMuted, forKey: soundMutedKey)
        dict.setObject(musicMuted, forKey: musicMutedKey)
        
        dict.setObject(gamesPlayed, forKey: gamesPlayedKey)
        dict.setObject(redWinCount, forKey: redWinCountKey)
        dict.setObject(blueWinCount, forKey: blueWinCountKey)
        dict.setObject(greenWinCount, forKey: greenWinCountKey)
        dict.setObject(yellowWinCount, forKey: yellowWinCountKey)
        dict.setObject(cyanWinCount, forKey: cyanWinCountKey)
        dict.setObject(purpleWinCount, forKey: purpleWinCountKey)
        dict.setObject(highestWager, forKey: highestWagerKey)
        
        // write to GameData.plist
        dict.writeToFile(path, atomically: false)
    }
    
    func setMusic(musicMuted: Bool) {
        self.musicMuted = musicMuted
    }
    
    func setSound(soundMuted: Bool) {
        self.soundMuted = soundMuted
    }
    
    func setDenomination(value: Int) {
        betDenomination = value
    }
    
    func subtractCoins(amount: Int) {
        coins -= amount
    }
    
    func addCoins(amount: Int) {
        coins += amount
        
        if coins > highscore {
            highscore = coins

            // Check achievement: Money in the Bank
            Achievements.update(.MoneyInTheBank)
            
            var value = 0

            if highscore >= 1000000 {
                value = 7
            } else if highscore >= 100000 {
                value = 6
            } else if highscore >= 10000 {
                value = 5
            } else if highscore >= 5000 {
                value = 4
            } else if highscore >= 1000 {
                value = 3
            } else if highscore >= 200 {
                value = 2
            } else if highscore >= 100 {
                value = 1
            }
            
            // DELETE: Debug this code
            while value > coinsUnlocked {
                coinsUnlocked += 1
                showUnlockedCoinHandler!()
            }
            
            // Check achievement: Coin Collector
            Achievements.update(.CoinCollector)
        }
    }
    
    func incrementGamesPlayed() {
        gamesPlayed += 1
        
        Achievements.update(.GamesPlayed)
    }
    
    func incrementWinCount(color: Color) {
        switch color {
        case .Blue:
            blueWinCount += 1
            Achievements.update(.BlueWin)
        case .Red:
            redWinCount += 1
            Achievements.update(.RedWin)
        case .Green:
            greenWinCount += 1
            Achievements.update(.GreenWin)
        case .Yellow:
            yellowWinCount += 1
            Achievements.update(.YellowWin)
        case .Cyan:
            cyanWinCount += 1
            Achievements.update(.CyanWin)
        case .Purple:
            purpleWinCount += 1
            Achievements.update(.PurpleWin)
        }
                
        // DELETE: Need to check if new level is reached whenever func is called
        // DELETE: Need to pop node when new level is reached
    }
}

