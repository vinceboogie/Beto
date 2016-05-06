//
//  AchievementsManager.swift
//  Beto
//
//  Created by Jem on 5/21/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

enum AchievementName: String {
    case GamesPlayed = "I think I'm Addicted"
    case HighestWager = "Stakes are high"
    case MoneyInTheBank = "Money in the Bank"
    case CoinCollector = "Coin Collector"
    case BlueWin = "Feeling a little Blue"
    case RedWin = "I'm a Vermillionaire"
    case GreenWin = "Thank you Verde much"
    case YellowWin = "Blonde baby, Blonde"
    case CyanWin = "Cyantifically Proven"
    case PurpleWin = "Back to the Fuchsia"
}

class AchievementsManager {
    private(set) var list = [Achievement]()
    
    init() {
        /*
         /********** AchievementName: Sample ***********/
         let sampleValues = [0, 0, 0]
         let sample = Achievement(name: "Achievement Template",
         requirementValues: sampleValues,
         requirements: ["This is an example \(sampleValues[0])", "This is an example \(sampleValues[1])", "This is an example \(sampleValues[2])"],
         rewards: [0,0,0])
         
         sample.calculateLevel = { () -> Int in
         var level = 0
         
         return level
         }
         
         sample.level = sample.calculateLevel!()
         
         sample.calculateProgress = { () -> Float in
         let progress = Float(1.0)
         
         return progress
         }
         
         sample.progress = sample.calculateProgress!()
         
         list.append(sample)
         */
        
        /********** AchievementName: CoinCollector ***********/
        let coinValues = [1, 4, 7]
        let coinCollector = Achievement(name: AchievementName.CoinCollector.rawValue,
                                 requirementValues: coinValues,
                                 requirements: ["Unlock a coin", "Unlock \(coinValues[1]) coins", "Unlock all coins"],
                                 rewards: [0,0,0])
        
        coinCollector.calculateLevel = { () -> Int in
            var level = 0
            
            if GameData.coinsUnlocked >= coinCollector.requirementValues[2] {
                level = 3
            } else if GameData.coinsUnlocked >= coinCollector.requirementValues[1] {
                level = 2
            } else if GameData.coinsUnlocked >= coinCollector.requirementValues[0] {
                level = 1
            }
            
            return level
        }
        
        coinCollector.level = coinCollector.calculateLevel!()
        
        coinCollector.calculateProgress = { () -> Double in
            let progress = Double(GameData.coinsUnlocked) / Double(coinCollector.requirementValues[coinCollector.level])
            
            return progress
        }
        
        coinCollector.progress = coinCollector.calculateProgress!()
        
        list.append(coinCollector)
        
        
        /********** Color Achievements ***********/
        let colorWinValues = [10, 50, 100]
        
        /********** AchievementName: BlueWin ***********/
        let blueWin = Achievement(name: AchievementName.BlueWin.rawValue,
                                  requirementValues: colorWinValues,
                                  requirements: colorWinRequirements(Color.Blue, values: colorWinValues),
                                  rewards: [0,0,0])
        
        blueWin.calculateLevel = { () -> Int in
            return self.colorWinLevel(GameData.blueWinCount, values: colorWinValues)
        }
        
        blueWin.level = blueWin.calculateLevel!()
        
        blueWin.calculateProgress = { () -> Double in
            let progress = Double(GameData.blueWinCount) / Double(blueWin.requirementValues[blueWin.level])
            
            return progress
        }
        
        blueWin.progress = blueWin.calculateProgress!()
        
        list.append(blueWin)
        
        
        /********** AchievementName: RedWin ***********/
        let redWin = Achievement(name: AchievementName.RedWin.rawValue,
                                 requirementValues: colorWinValues,
                                 requirements: colorWinRequirements(Color.Red, values: colorWinValues),
                                 rewards: [0,0,0])
        
        redWin.calculateLevel = { () -> Int in
            return self.colorWinLevel(GameData.redWinCount, values: colorWinValues)
        }
        
        redWin.level = redWin.calculateLevel!()
        
        redWin.calculateProgress = { () -> Double in
            let progress = Double(GameData.redWinCount) / Double(redWin.requirementValues[redWin.level])
            
            return progress
        }
        
        redWin.progress = redWin.calculateProgress!()
        
        list.append(redWin)
        
        
        /********** AchievementName: GreenWin ***********/
        let greenWin = Achievement(name: AchievementName.GreenWin.rawValue,
                                   requirementValues: colorWinValues,
                                   requirements: colorWinRequirements(Color.Green, values: colorWinValues),
                                   rewards: [0,0,0])
        
        greenWin.calculateLevel = { () -> Int in
            return self.colorWinLevel(GameData.greenWinCount, values: colorWinValues)
        }
        
        greenWin.level = greenWin.calculateLevel!()
        
        greenWin.calculateProgress = { () -> Double in
            let progress = Double(GameData.greenWinCount) / Double(greenWin.requirementValues[greenWin.level])
            
            return progress
        }
        
        greenWin.progress = greenWin.calculateProgress!()
        
        list.append(greenWin)
        
        
        /********** AchievementName: YellowWin ***********/
        let yellowWin = Achievement(name: AchievementName.YellowWin.rawValue,
                                    requirementValues: colorWinValues,
                                    requirements: colorWinRequirements(Color.Yellow, values: colorWinValues),
                                    rewards: [0,0,0])
        
        yellowWin.calculateLevel = { () -> Int in
            return self.colorWinLevel(GameData.yellowWinCount, values: colorWinValues)
        }
        
        yellowWin.level = yellowWin.calculateLevel!()
        
        yellowWin.calculateProgress = { () -> Double in
            let progress = Double(GameData.yellowWinCount) / Double(yellowWin.requirementValues[yellowWin.level])
            
            return progress
        }
        
        yellowWin.progress = yellowWin.calculateProgress!()
        
        list.append(yellowWin)
        
        
        /********** AchievementName: CyanWin ***********/
        let cyanWin = Achievement(name: AchievementName.CyanWin.rawValue,
                                  requirementValues: colorWinValues,
                                  requirements: colorWinRequirements(Color.Cyan, values: colorWinValues),
                                  rewards: [0,0,0])
        
        cyanWin.calculateLevel = { () -> Int in
            return self.colorWinLevel(GameData.cyanWinCount, values: colorWinValues)
        }
        
        cyanWin.level = cyanWin.calculateLevel!()
        
        cyanWin.calculateProgress = { () -> Double in
            let progress = Double(GameData.cyanWinCount) / Double(cyanWin.requirementValues[cyanWin.level])
            
            return progress
        }
        
        cyanWin.progress = cyanWin.calculateProgress!()
        
        list.append(cyanWin)
        
        
        /********** AchievementName: PurpleWin ***********/
        let purpleWin = Achievement(name: AchievementName.PurpleWin.rawValue,
                                    requirementValues: colorWinValues,
                                    requirements: colorWinRequirements(Color.Purple, values: colorWinValues),
                                    rewards: [0,0,0])
        
        purpleWin.calculateLevel = { () -> Int in
            return self.colorWinLevel(GameData.purpleWinCount, values: colorWinValues)
        }
        
        purpleWin.level = purpleWin.calculateLevel!()
        
        purpleWin.calculateProgress = { () -> Double in
            let progress = Double(GameData.purpleWinCount) / Double(purpleWin.requirementValues[purpleWin.level])
            
            return progress
        }
        
        purpleWin.progress = purpleWin.calculateProgress!()
        
        list.append(purpleWin)
        
        
        /********** AchievementName: GamesPlayed ***********/
        let gamesPlayedValues = [100, 500, 1000]
        let gamesPlayed = Achievement(name: AchievementName.GamesPlayed.rawValue,
                                      requirementValues: gamesPlayedValues,
                                      requirements: ["Play \(gamesPlayedValues[0]) times", "Play \(gamesPlayedValues[1]) times", "Play \(gamesPlayedValues[2]) times"],
                                      rewards: [0,0,0])
        
        gamesPlayed.calculateLevel = { () -> Int in
            var level = 0
            
            if GameData.gamesPlayed >= gamesPlayed.requirementValues[2] {
                level = 3
            } else if GameData.gamesPlayed >= gamesPlayed.requirementValues[1] {
                level = 2
            } else if GameData.gamesPlayed >= gamesPlayed.requirementValues[0] {
                level = 1
            }
            
            return level
        }
        
        gamesPlayed.level = gamesPlayed.calculateLevel!()
        
        gamesPlayed.calculateProgress = { () -> Double in
            let progress = Double(GameData.gamesPlayed) / Double(gamesPlayed.requirementValues[gamesPlayed.level])
    
            return progress
        }
        
        gamesPlayed.progress = gamesPlayed.calculateProgress!()
        
        list.append(gamesPlayed)
        
        
        /********** AchievementName: MoneyInTheBank ***********/
        let moneyValues = [10000, 100000, 1000000]
        let moneyInTheBank = Achievement(name: AchievementName.MoneyInTheBank.rawValue,
                                 requirementValues: moneyValues,
                                 requirements: ["Reach a highscore of \(moneyValues[0])", "Reach a highscore of \(moneyValues[1])", "Reach a highscore of \(moneyValues[2])"],
                                 rewards: [0,0,0])
        
        moneyInTheBank.calculateLevel = { () -> Int in
            var level = 0
            
            if GameData.highscore > moneyInTheBank.requirementValues[2] {
                level = 3
            } else if GameData.highscore > moneyInTheBank.requirementValues[1] {
                level = 2
            } else if GameData.highscore > moneyInTheBank.requirementValues[0] {
                level = 1
            }
            
            return level
        }
        
        moneyInTheBank.level = moneyInTheBank.calculateLevel!()
        
        moneyInTheBank.calculateProgress = { () -> Double in
            let progress = Double(GameData.highscore) / Double(moneyInTheBank.requirementValues[moneyInTheBank.level])
            
            return progress
        }
        
        moneyInTheBank.progress = moneyInTheBank.calculateProgress!()
        
        list.append(moneyInTheBank)
        
        
        /********** AchievementName: HighestWager ***********/
        let highestWagerValues = [1000, 10000, 100000]
        let highestWager = Achievement(name: AchievementName.HighestWager.rawValue,
                                       requirementValues: highestWagerValues,
                                       requirements: ["Place a \(highestWagerValues[0]) bet on any color", "Place a \(highestWagerValues[1]) bet on any color", "Place a \(highestWagerValues[2]) bet on any color"],
                                       rewards: [0,0,0])
        
        highestWager.calculateLevel = { () -> Int in
            var level = 0
            
            if GameData.highestWager >= highestWager.requirementValues[2] {
                level = 3
            } else if GameData.highestWager >= highestWager.requirementValues[1] {
                level = 2
            } else if GameData.highestWager >= highestWager.requirementValues[0] {
                level = 1
            }
            
            return level
        }
        
        highestWager.level = highestWager.calculateLevel!()
        
        highestWager.calculateProgress = { () -> Double in
            let progress = Double(GameData.highestWager) / Double(gamesPlayed.requirementValues[gamesPlayed.level])
            
            return progress
        }
        
        highestWager.progress = highestWager.calculateProgress!()
        
        list.append(highestWager)
        
    }
    
    func update(name: AchievementName) {
        for achievement in list {
            if achievement.name == name.rawValue {
                achievement.update()
            }
        }
    }
    
    private func colorWinRequirements(color: Color, values: [Int]) -> [String]{
        return ["Place \(values[0]) winning bets on \(color.rawValue)", "Place \(values[1]) winning bets on \(color.rawValue)", "Place \(values[2]) winning bets on \(color.rawValue)"]
    }
    
    private func colorWinLevel(winCount: Int, values: [Int]) -> Int {
        var level = 0

        if winCount >= values[2] {
            level = 3
        } else if winCount >= values[1] {
            level = 2
        } else if winCount >= values[0] {
            level = 1
        }

        return level
    }
}