//
//  GameDataManager.swift
//  Beto
//
//  Created by Jem on 2/23/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

class GameDataManager {
    // Keys
    private let starCoinsKey = "starCoins"
    private let coinsKey = "coins"
    private let highscoreKey = "highscore"
    private let gamesPlayedKey = "gamesPlayed"
    private let coinsUnlockedKey = "coinsUnlocked"
    private let betDenominationKey = "betDenomination"
    private let soundMutedKey = "soundMuted"
    private let musicMutedKey = "musicMuted"
    private let currentThemeNameKey = "currentThemeName"
    private let autoLoadEnabledKey = "autoLoadEnabled"
    private let unlockedThemesKey = "unlockedThemes"
    private let achievementTrackerKey = "achievementTracker"
    private let powerUpsKey = "powerUps"
    private let rewardsDiceKey = "rewardsDice"
    
    // Plist Variables
    private(set) var starCoins: Int
    private(set) var coins: Int
    private(set) var highscore: Int
    private(set) var gamesPlayed: Int
    private(set) var coinsUnlocked: Int
    private(set) var betDenomination: Int
    private(set) var soundMuted: Bool
    private(set) var musicMuted: Bool
    private(set) var autoLoadEnabled: Bool
    private(set) var currentThemeName: String
    private(set) var unlockedThemes: [String]
    private(set) var achievementTracker: [String:Int]
    private(set) var powerUps: [String:Int]
    private(set) var rewardsDice: [String:Int]
    
    // Non-plist variables
    private(set) var theme: Theme
    private(set) var rewardChance: Int
    
    var unlockedCoinHandler: (() -> ())?
    var unlockedLevelHandler: ((Achievement) -> ())?
        
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
        
        let dict = NSDictionary(contentsOfFile: path)!
        
        starCoins = dict.objectForKey(starCoinsKey) as! Int
        coins = dict.objectForKey(coinsKey) as! Int
        highscore = dict.objectForKey(highscoreKey) as! Int
        gamesPlayed = dict.objectForKey(gamesPlayedKey) as! Int
        coinsUnlocked = dict.objectForKey(coinsUnlockedKey) as! Int
        betDenomination = dict.objectForKey(betDenominationKey) as! Int
        soundMuted = dict.objectForKey(soundMutedKey) as! Bool
        musicMuted = dict.objectForKey(musicMutedKey) as! Bool
        autoLoadEnabled = dict.objectForKey(autoLoadEnabledKey) as! Bool
        currentThemeName = dict.objectForKey(currentThemeNameKey) as! String
        unlockedThemes = dict.objectForKey(unlockedThemesKey) as! [String]
        achievementTracker = dict.objectForKey(achievementTrackerKey) as! [String:Int]
        powerUps = dict.objectForKey(powerUpsKey) as! [String:Int]
        rewardsDice = dict.objectForKey(rewardsDiceKey) as! [String:Int]

        theme = Theme(themeName: currentThemeName, unlocked: true)
        rewardChance = 0
    }
    
    func save() {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory = paths[0] as NSString
        let path = documentsDirectory.stringByAppendingPathComponent("GameData.plist")
        let dict: NSMutableDictionary = ["XInitializerItem": "DoNotEverChangeMe"]
        
        // save values
        dict.setObject(starCoins, forKey: starCoinsKey)
        dict.setObject(coins, forKey: coinsKey)
        dict.setObject(highscore, forKey: highscoreKey)
        dict.setObject(gamesPlayed, forKey: gamesPlayedKey)
        dict.setObject(coinsUnlocked, forKey: coinsUnlockedKey)
        dict.setObject(betDenomination, forKey: betDenominationKey)
        dict.setObject(soundMuted, forKey: soundMutedKey)
        dict.setObject(musicMuted, forKey: musicMutedKey)
        dict.setObject(autoLoadEnabled, forKey: autoLoadEnabledKey)
        dict.setObject(currentThemeName, forKey: currentThemeNameKey)
        dict.setObject(unlockedThemes, forKey: unlockedThemesKey)
        dict.setObject(achievementTracker, forKey: achievementTrackerKey)
        dict.setObject(powerUps, forKey: powerUpsKey)
        dict.setObject(rewardsDice, forKey: rewardsDiceKey)
        
        // write to GameData.plist
        dict.writeToFile(path, atomically: true)
    }
    
    func changeTheme(theme: Theme) {
        currentThemeName = theme.name
        self.theme = theme
    }
    
    func addPurchasedTheme(themeName: String) {
        unlockedThemes.append(themeName)
    }
    
    func setMusic(musicMuted: Bool) {
        self.musicMuted = musicMuted
    }
    
    func setSound(soundMuted: Bool) {
        self.soundMuted = soundMuted
    }
    
    func toggleAutoLoad() {
        autoLoadEnabled = !autoLoadEnabled
    }
    
    func setDenomination(value: Int) {
        betDenomination = value
    }
    
    func addStarCoins(amount: Int) {
        starCoins += amount
    }
    
    func subtractStarCoins(amount: Int) {
        starCoins -= amount
    }
    
    func addCoins(amount: Int) {
        let max = 999999999
        
        if (coins + amount) > max {
            coins = max
            
            // DELETE: Add ultimate reward when player reach max
        } else {
            coins += amount
        }
        
        if coins > highscore {
            highscore = coins
            Achievements.update(.MoneyInTheBank)
            
            var index = 0

            for value in Constant.CoinUnlockedAt {                
                if highscore >= value {
                    index = 1 + Constant.CoinUnlockedAt.indexOf(value)!
                } else {
                    break
                }
            }
            
            while index > coinsUnlocked {
                coinsUnlocked += 1
                unlockedCoinHandler!()
            }
            
            Achievements.update(.CoinCollector)
            }
    }
    
    func subtractCoins(amount: Int) {
        coins -= amount
    }
    
    func incrementGamesPlayed() {
        gamesPlayed += 1
    }
    
    func decrementGamesPlayed() {
        gamesPlayed -= 1
    }
    
    func increaseRewardChance(num: Int) {
        // Reward chance increases by 3/6/9 % based on number of colors selected
        rewardChance += num * 3
    }
    
    func resetRewardChance() {
        rewardChance = 0
    }
    
    func incrementAchievement(name: AchievementName) {
        if let value = achievementTracker[name.rawValue] {
            achievementTracker[name.rawValue] = value + 1
        }
        
        Achievements.update(name)
    }
    
    func decrementAchievement(name: AchievementName) {
        if let value = achievementTracker[name.rawValue] {
            achievementTracker[name.rawValue] = value - 1
        }
        
        Achievements.update(name)
    }
    
    func updateHighestWager(wager: Int) {
        let key = AchievementName.HighestWager.rawValue
        
        if wager > achievementTracker[key] {
            achievementTracker[key] = wager
            
            Achievements.update(.HighestWager)
        }
    }
    
    func addPowerUpCount(powerUpKey: String, num: Int) {
        if let value = powerUps[powerUpKey] {
            powerUps[powerUpKey] = value + num
        }
    }
    
    func subtractPowerUpCount(powerUpKey: String, num: Int) {
        if let value = powerUps[powerUpKey] {
            powerUps[powerUpKey] = value - num
        }
    }
    
    func getRewardsDiceCount(diceKey: String) -> Int {
        if let value = rewardsDice[diceKey] {
            return value
        } else {
            return -1
        }
    }
    
    func addRewardsDiceCount(diceKey: String, num: Int) {
        if let value = rewardsDice[diceKey] {
            rewardsDice[diceKey] = value + num
        }
    }
    
    func subtractRewardsDiceCount(diceKey: String, num: Int) {
        if let value = rewardsDice[diceKey] {
            rewardsDice[diceKey] = value - num
        }
    }
}