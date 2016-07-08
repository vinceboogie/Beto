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
    private(set) var themeName: String
    private(set) var theme: Theme
    private(set) var bonusPayoutEndTime: NSDate
    
    var shouldPayBonus: Bool
    
    private(set) var gamesPlayed: Int
    private(set) var redWinCount: Int
    private(set) var blueWinCount: Int
    private(set) var greenWinCount: Int
    private(set) var yellowWinCount: Int
    private(set) var cyanWinCount: Int
    private(set) var purpleWinCount: Int
    private(set) var highestWager: Int
    
    var unlockedCoinHandler: (() -> ())?
    var unlockedLevelHandler: ((Achievement) -> ())?
    
    // keys
    private let coinsKey = "coins"
    private let highscoreKey = "highscore"
    private let betDenominationKey = "betDenomination"
    private let coinsUnlockedKey = "coinsUnlocked"
    private let soundMutedKey = "soundMuted"
    private let musicMutedKey = "musicMuted"
    private let themeNameKey = "themeName"
    private let bonusPayoutEndTimeKey = "bonusPayoutEndTime"

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
            themeName = dict.objectForKey(themeNameKey) as! String
            bonusPayoutEndTime = dict.objectForKey(bonusPayoutEndTimeKey) as! NSDate
            
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
            themeName = "Default"
            bonusPayoutEndTime = NSDate()
            
            gamesPlayed = 0
            redWinCount = 0
            blueWinCount = 0
            greenWinCount = 0
            yellowWinCount = 0
            cyanWinCount = 0
            purpleWinCount = 0
            highestWager = 0
        }
        
        theme = Theme(themeName: themeName, unlocked: true)
        shouldPayBonus = false
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
        dict.setObject(themeName, forKey: themeNameKey)
        dict.setObject(bonusPayoutEndTime, forKey: bonusPayoutEndTimeKey)
        
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
    
    func changeTheme(theme: Theme) {
        themeName = theme.name
        self.theme = theme
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
    }
    
    func updateHighestWager(wager: Int) {
        if wager > highestWager {
            highestWager = wager
    
            Achievements.update(.HighestWager)
        }
    }
    
    func setBonusPayoutTime(hours: Int) {
        let timeInterval: Double = 60 * 60 * Double(hours)
        
        if bonusPayoutEnabled() {
            bonusPayoutEndTime = bonusPayoutEndTime.dateByAddingTimeInterval(timeInterval)
        } else {
            bonusPayoutEndTime = NSDate().dateByAddingTimeInterval(timeInterval)
        }
    }
    
    func bonusTimeLeft() -> NSTimeInterval {
       return bonusPayoutEndTime.timeIntervalSinceDate(NSDate())
    }
    
    func bonusPayoutEnabled() -> Bool {
        if NSDate().compare(bonusPayoutEndTime) == .OrderedAscending {
            return true
        } else {
            return false
        }
    }

    // DELETE: Test
//    func bonusPayoutTest() {
//        let currentTime = NSDate()
//
//        let formatter = NSDateFormatter()
//        formatter.locale = NSLocale.currentLocale()
//        formatter.dateStyle = .LongStyle
//        formatter.timeStyle = .MediumStyle
//        
//        // DELETE: Test
//        let current = NSDate()
//        let interval = Int(bonusPayoutEndTime.timeIntervalSinceDate(current))
//
//        let seconds = interval % 60
//        let minutes = (interval / 60) % 60
//        let hours = interval / 3600
//        
//        print("\(hours):\(minutes):\(seconds)")
//        
//        print(formatter.stringFromDate(currentTime))
//        print(formatter.stringFromDate(bonusPayoutEndTime))
//        print(bonusPayoutEnabled())
//        
//    }
}

