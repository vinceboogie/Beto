//
//  AchievementsManager.swift
//  Beto
//
//  Created by Jem on 5/21/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

enum AchievementName: String {
    case GamesPlayed
    case HighestWager
    case MoneyInTheBank
    case CoinCollector
    case BlueWin
    case RedWin
    case GreenWin
    case YellowWin
    case CyanWin
    case PurpleWin
    case Lifeline
    case RewardBoost
    case DoubleDice
    case DoublePayout
    case TriplePayout
    case Reroll
}

class AchievementsManager {
    private(set) var list = [Achievement]()
    
    init() {
        /* 
         /********** AchievementName: Sample ***********/
         let sampleValues = [0, 0, 0]
         let sample = Achievement(name: AchievementName.CHANGETHIS.rawValue,
                                  displayName: "Achievement Template",
                                  requirementValues: sampleValues,
                                  requirements: ["This is an example \(sampleValues[0])",
                                    "This is an example \(sampleValues[1])",
                                    "This is an example \(sampleValues[2])"],
                                  rewards: [Reward(bonusPayoutMinutes: 1),
                                    Reward(bonusPayoutMinutes: 2),
                                    Reward(bonusPayoutMinutes: 4)])
         
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
        
        /********** AchievementName: GamesPlayed ***********/
        let gamesPlayedValues = [100, 1000, 10000]
        let gamesPlayed = Achievement(name: AchievementName.GamesPlayed.rawValue,
                                      displayName: "Can't Put It Down",
                                      requirementValues: gamesPlayedValues,
                                      requirements: ["Play \(gamesPlayedValues[0]) times",
                                        "Play \(gamesPlayedValues[1]) times",
                                        "Play \(gamesPlayedValues[2]) times"],
                                      rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                        Reward(starCoins: 5, rewardsDice: .Platinum),
                                        Reward(starCoins: 10, rewardsDice: .Diamond)])
        
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
            var progress = 0.0
            
            if gamesPlayed.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.gamesPlayed) / Double(gamesPlayed.requirementValues[gamesPlayed.level])
            }
            
            return progress
        }
        
        gamesPlayed.progress = gamesPlayed.calculateProgress!()
        
        list.append(gamesPlayed)
        
        
        /********** AchievementName: CoinCollector ***********/
        let coinValues = [1, 4, 7]
        let coinCollector = Achievement(name: AchievementName.CoinCollector.rawValue,
                                        displayName: "Coin Collector",
                                        requirementValues: coinValues,
                                        requirements: ["Unlock a coin",
                                            "Unlock \(coinValues[1]) coins",
                                            "Unlock all coins"],
                                        rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                            Reward(starCoins: 5, rewardsDice: .Platinum),
                                            Reward(starCoins: 10, rewardsDice: .Diamond)])
    
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
            var progress = 0.0
            
            if coinCollector.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.coinsUnlocked) / Double(coinCollector.requirementValues[coinCollector.level])
            }
            
            return progress
        }
        
        coinCollector.progress = coinCollector.calculateProgress!()
        
        list.append(coinCollector)
        
        
        /********** Color Achievements ***********/
        let colorWinValues = [10, 100, 1000]
        
        /********** AchievementName: BlueWin ***********/
        let blueWin = Achievement(name: AchievementName.BlueWin.rawValue,
                                  displayName: "I've Got The Blues",
                                  requirementValues: colorWinValues,
                                  requirements: colorWinRequirements(Color.Blue, values: colorWinValues),
                                  rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 5, rewardsDice: .Platinum),
                                    Reward(starCoins: 10, rewardsDice: .Diamond)])
        
        
        blueWin.calculateLevel = { () -> Int in
            return self.colorWinLevel(GameData.achievementTracker[blueWin.name]!, values: colorWinValues)
        }
        
        blueWin.level = blueWin.calculateLevel!()
        
        blueWin.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if blueWin.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[blueWin.name]!) / Double(blueWin.requirementValues[blueWin.level])
            }
            
            return progress
        }
        
        blueWin.progress = blueWin.calculateProgress!()
        
        list.append(blueWin)
        
        
        /********** AchievementName: RedWin ***********/
        let redWin = Achievement(name: AchievementName.RedWin.rawValue,
                                  displayName: "One in a Vermillion",
                                  requirementValues: colorWinValues,
                                  requirements: colorWinRequirements(Color.Red, values: colorWinValues),
                                  rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 5, rewardsDice: .Platinum),
                                    Reward(starCoins: 10, rewardsDice: .Diamond)])
        
        redWin.calculateLevel = { () -> Int in
            return self.colorWinLevel(GameData.achievementTracker[redWin.name]!, values: colorWinValues)
        }
        
        redWin.level = redWin.calculateLevel!()
        
        redWin.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if redWin.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[redWin.name]!) / Double(redWin.requirementValues[redWin.level])
            }
            
            return progress
        }
        
        redWin.progress = redWin.calculateProgress!()
        
        list.append(redWin)
        
        
        /********** AchievementName: GreenWin ***********/
        let greenWin = Achievement(name: AchievementName.GreenWin.rawValue,
                                 displayName: "Thank You Verde Much",
                                 requirementValues: colorWinValues,
                                 requirements: colorWinRequirements(Color.Green, values: colorWinValues),
                                 rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 5, rewardsDice: .Platinum),
                                    Reward(starCoins: 10, rewardsDice: .Diamond)])
        
        greenWin.calculateLevel = { () -> Int in
            return self.colorWinLevel(GameData.achievementTracker[greenWin.name]!, values: colorWinValues)
        }
        
        greenWin.level = greenWin.calculateLevel!()
        
        greenWin.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if greenWin.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[greenWin.name]!) / Double(greenWin.requirementValues[greenWin.level])
            }
            
            return progress
        }
        
        greenWin.progress = greenWin.calculateProgress!()
        
        list.append(greenWin)
        
        
        /********** AchievementName: YellowWin ***********/
        let yellowWin = Achievement(name: AchievementName.YellowWin.rawValue,
                                 displayName: "You Had Me At Yellow",
                                 requirementValues: colorWinValues,
                                 requirements: colorWinRequirements(Color.Yellow, values: colorWinValues),
                                 rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 5, rewardsDice: .Platinum),
                                    Reward(starCoins: 10, rewardsDice: .Diamond)])
        
        yellowWin.calculateLevel = { () -> Int in
            return self.colorWinLevel(GameData.achievementTracker[yellowWin.name]!, values: colorWinValues)
        }
        
        yellowWin.level = yellowWin.calculateLevel!()
        
        yellowWin.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if yellowWin.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[yellowWin.name]!) / Double(yellowWin.requirementValues[yellowWin.level])
            }
            
            return progress
        }
        
        yellowWin.progress = yellowWin.calculateProgress!()
        
        list.append(yellowWin)
        
        
        /********** AchievementName: CyanWin ***********/
        let cyanWin = Achievement(name: AchievementName.CyanWin.rawValue,
                                 displayName: "Cyantifically Proven",
                                 requirementValues: colorWinValues,
                                 requirements: colorWinRequirements(Color.Cyan, values: colorWinValues),
                                 rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 5, rewardsDice: .Platinum),
                                    Reward(starCoins: 10, rewardsDice: .Diamond)])
        
        cyanWin.calculateLevel = { () -> Int in
            return self.colorWinLevel(GameData.achievementTracker[cyanWin.name]!, values: colorWinValues)
        }
        
        cyanWin.level = cyanWin.calculateLevel!()
        
        cyanWin.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if cyanWin.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[cyanWin.name]!) / Double(cyanWin.requirementValues[cyanWin.level])
            }
            
            return progress
        }
        
        cyanWin.progress = cyanWin.calculateProgress!()
        
        list.append(cyanWin)
        
        
        /********** AchievementName: PurpleWin ***********/
        let purpleWin = Achievement(name: AchievementName.PurpleWin.rawValue,
                                 displayName: "Back to the Fuschia",
                                 requirementValues: colorWinValues,
                                 requirements: colorWinRequirements(Color.Purple, values: colorWinValues),
                                 rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 5, rewardsDice: .Platinum),
                                    Reward(starCoins: 10, rewardsDice: .Diamond)])
        
        purpleWin.calculateLevel = { () -> Int in
            return self.colorWinLevel(GameData.achievementTracker[purpleWin.name]!, values: colorWinValues)
        }
        
        purpleWin.level = purpleWin.calculateLevel!()
        
        purpleWin.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if purpleWin.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[purpleWin.name]!) / Double(purpleWin.requirementValues[purpleWin.level])
            }
            
            return progress
        }
        
        purpleWin.progress = purpleWin.calculateProgress!()
        
        list.append(purpleWin)
        
        /********** AchievementName: MoneyInTheBank ***********/
        let moneyValues = [10000, 100000, 1000000]
        let moneyInTheBank = Achievement(name: AchievementName.MoneyInTheBank.rawValue,
                                 displayName: "Money in the Bank",
                                 requirementValues: moneyValues,
                                 requirements: ["Reach a highscore of \(moneyValues[0])",
                                    "Reach a highscore of \(moneyValues[1])",
                                    "Reach a highscore of \(moneyValues[2])"],
                                 rewards: [Reward(starCoins: 3, rewardsDice: .Platinum),
                                    Reward(starCoins: 5, rewardsDice: .Diamond),
                                    Reward(starCoins: 10, rewardsDice: .Ruby)])
        
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
            var progress = 0.0
            
            if moneyInTheBank.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.highscore) / Double(moneyInTheBank.requirementValues[moneyInTheBank.level])
            }
            
            return progress
        }
        
        moneyInTheBank.progress = moneyInTheBank.calculateProgress!()
        
        list.append(moneyInTheBank)
        
        
        /********** AchievementName: HighestWager ***********/
        let highestWagerValues = [1000, 100000, 1000000]
        let highestWager = Achievement(name: AchievementName.HighestWager.rawValue,
                                       displayName: "The Gambler",
                                       requirementValues: highestWagerValues,
                                       requirements: ["Place a \(highestWagerValues[0]) bet on any color",
                                            "Place a \(highestWagerValues[1]) bet on any color",
                                            "Place a \(highestWagerValues[2]) bet on any color"],
                                       rewards: [Reward(starCoins: 3, rewardsDice: .Platinum),
                                            Reward(starCoins: 5, rewardsDice: .Diamond),
                                            Reward(starCoins: 10, rewardsDice: .Ruby)])
        
        highestWager.calculateLevel = { () -> Int in
            var level = 0
            
            if GameData.achievementTracker[highestWager.name] >= highestWager.requirementValues[2] {
                level = 3
            } else if GameData.achievementTracker[highestWager.name] >= highestWager.requirementValues[1] {
                level = 2
            } else if GameData.achievementTracker[highestWager.name] >= highestWager.requirementValues[0] {
                level = 1
            }
            
            return level
        }
        
        highestWager.level = highestWager.calculateLevel!()
        
        highestWager.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if highestWager.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[highestWager.name]!) / Double(highestWager.requirementValues[highestWager.level])
            }
            
            return progress
        }
        
        highestWager.progress = highestWager.calculateProgress!()
        
        list.append(highestWager)
        
        
        /********** Power Up Achievements ***********/
        let powerUpValues = [10, 100, 1000]
        
        
        /********** AchievementName: Lifeline ***********/
        let lifeline = Achievement(name: AchievementName.Lifeline.rawValue,
                                   displayName: "Half Off",
                                   requirementValues: powerUpValues,
                                   requirements: powerUpRequirements(AchievementName.Lifeline.rawValue, values: powerUpValues),
                                   rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 5, rewardsDice: .Platinum),
                                    Reward(starCoins: 10, rewardsDice: .Diamond)])
        
        lifeline.calculateLevel = { () -> Int in
            var level = 0
            
            if GameData.achievementTracker[lifeline.name] >= lifeline.requirementValues[2] {
                level = 3
            } else if GameData.achievementTracker[lifeline.name] >= lifeline.requirementValues[1] {
                level = 2
            } else if GameData.achievementTracker[lifeline.name] >= lifeline.requirementValues[0] {
                level = 1
            }
            
            return level
        }
        
        lifeline.level = lifeline.calculateLevel!()
        
        lifeline.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if lifeline.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[lifeline.name]!) / Double(lifeline.requirementValues[lifeline.level])
            }
            
            return progress
        }
        
        lifeline.progress = lifeline.calculateProgress!()
        
        list.append(lifeline)
        
        /********** AchievementName: RewardBoost ***********/
        let rewardBoost = Achievement(name: AchievementName.RewardBoost.rawValue,
                                   displayName: "Finders Keepers",
                                   requirementValues: powerUpValues,
                                   requirements: powerUpRequirements(AchievementName.RewardBoost.rawValue, values: powerUpValues),
                                   rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 5, rewardsDice: .Platinum),
                                    Reward(starCoins: 10, rewardsDice: .Diamond)])
        
        rewardBoost.calculateLevel = { () -> Int in
            var level = 0
            
            if GameData.achievementTracker[rewardBoost.name] >= rewardBoost.requirementValues[2] {
                level = 3
            } else if GameData.achievementTracker[rewardBoost.name] >= rewardBoost.requirementValues[1] {
                level = 2
            } else if GameData.achievementTracker[rewardBoost.name] >= rewardBoost.requirementValues[0] {
                level = 1
            }
            
            return level
        }
        
        rewardBoost.level = rewardBoost.calculateLevel!()
        
        rewardBoost.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if rewardBoost.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[rewardBoost.name]!) / Double(rewardBoost.requirementValues[rewardBoost.level])
            }
            
            return progress
        }
        
        rewardBoost.progress = rewardBoost.calculateProgress!()
        
        list.append(rewardBoost)
        
        
        /********** AchievementName: DoubleDice ***********/
        let doubleDice = Achievement(name: AchievementName.DoubleDice.rawValue,
                                     displayName: "Double The Fun",
                                     requirementValues: powerUpValues,
                                     requirements: powerUpRequirements(AchievementName.DoubleDice.rawValue, values: powerUpValues),
                                     rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                        Reward(starCoins: 5, rewardsDice: .Platinum),
                                        Reward(starCoins: 10, rewardsDice: .Diamond)])
        
        doubleDice.calculateLevel = { () -> Int in
            var level = 0
            
            if GameData.achievementTracker[doubleDice.name] >= doubleDice.requirementValues[2] {
                level = 3
            } else if GameData.achievementTracker[doubleDice.name] >= doubleDice.requirementValues[1] {
                level = 2
            } else if GameData.achievementTracker[doubleDice.name] >= doubleDice.requirementValues[0] {
                level = 1
            }
            
            return level
        }
        
        doubleDice.level = doubleDice.calculateLevel!()
        
        doubleDice.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if doubleDice.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[doubleDice.name]!) / Double(doubleDice.requirementValues[doubleDice.level])
            }
            
            return progress
        }
        
        doubleDice.progress = doubleDice.calculateProgress!()
        
        list.append(doubleDice)
        
        
        /********** AchievementName: DoublePayout ***********/
        let doublePayout = Achievement(name: AchievementName.DoublePayout.rawValue,
                                     displayName: "Double The Pleasure",
                                     requirementValues: powerUpValues,
                                     requirements: powerUpRequirements(AchievementName.DoublePayout.rawValue, values: powerUpValues),
                                     rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                        Reward(starCoins: 5, rewardsDice: .Platinum),
                                        Reward(starCoins: 10, rewardsDice: .Diamond)])
        
        doublePayout.calculateLevel = { () -> Int in
            var level = 0
            
            if GameData.achievementTracker[doublePayout.name] >= doublePayout.requirementValues[2] {
                level = 3
            } else if GameData.achievementTracker[doublePayout.name] >= doublePayout.requirementValues[1] {
                level = 2
            } else if GameData.achievementTracker[doublePayout.name] >= doublePayout.requirementValues[0] {
                level = 1
            }
            
            return level
        }
        
        doublePayout.level = doublePayout.calculateLevel!()
        
        doublePayout.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if doublePayout.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[doublePayout.name]!) / Double(doublePayout.requirementValues[doublePayout.level])
            }
            
            return progress
        }
        
        doublePayout.progress = doublePayout.calculateProgress!()
        
        list.append(doublePayout)
        
        
        /********** AchievementName: TriplePayout ***********/
        let triplePayout = Achievement(name: AchievementName.TriplePayout.rawValue,
                                       displayName: "Three Point Play",
                                       requirementValues: powerUpValues,
                                       requirements: powerUpRequirements(AchievementName.TriplePayout.rawValue, values: powerUpValues),
                                       rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                        Reward(starCoins: 5, rewardsDice: .Platinum),
                                        Reward(starCoins: 10, rewardsDice: .Diamond)])
        
        triplePayout.calculateLevel = { () -> Int in
            var level = 0
            
            if GameData.achievementTracker[triplePayout.name] >= triplePayout.requirementValues[2] {
                level = 3
            } else if GameData.achievementTracker[triplePayout.name] >= triplePayout.requirementValues[1] {
                level = 2
            } else if GameData.achievementTracker[triplePayout.name] >= triplePayout.requirementValues[0] {
                level = 1
            }
            
            return level
        }
        
        triplePayout.level = triplePayout.calculateLevel!()
        
        triplePayout.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if triplePayout.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[triplePayout.name]!) / Double(triplePayout.requirementValues[triplePayout.level])
            }
            
            return progress
        }
        
        triplePayout.progress = triplePayout.calculateProgress!()
        
        list.append(triplePayout)
        
        
        /********** AchievementName: Reroll ***********/
        let reroll = Achievement(name: AchievementName.Reroll.rawValue,
                                   displayName: "Baby One More Time",
                                   requirementValues: powerUpValues,
                                   requirements: powerUpRequirements(AchievementName.Reroll.rawValue, values: powerUpValues),
                                   rewards: [Reward(starCoins: 1, rewardsDice: .Gold),
                                    Reward(starCoins: 5, rewardsDice: .Platinum),
                                    Reward(starCoins: 10, rewardsDice: .Diamond)])
        
        reroll.calculateLevel = { () -> Int in
            var level = 0
            
            if GameData.achievementTracker[reroll.name] >= reroll.requirementValues[2] {
                level = 3
            } else if GameData.achievementTracker[reroll.name] >= reroll.requirementValues[1] {
                level = 2
            } else if GameData.achievementTracker[reroll.name] >= reroll.requirementValues[0] {
                level = 1
            }
            
            return level
        }
        
        reroll.level = reroll.calculateLevel!()
        
        reroll.calculateProgress = { () -> Double in
            var progress = 0.0
            
            if reroll.level == 3 {
                progress = 1.0
            } else {
                progress = Double(GameData.achievementTracker[reroll.name]!) / Double(reroll.requirementValues[reroll.level])
            }
            
            return progress
        }
        
        reroll.progress = reroll.calculateProgress!()
        
        list.append(reroll)
    }
    
    func update(name: AchievementName) {
        if let achievement = get(name) {
            achievement.update()
        }
    }
    
    func get(name: AchievementName) -> Achievement! {
        for achievement in list {
            if achievement.name == name.rawValue {
                return achievement
            }
        }
        
        return nil
    }
    
    private func colorWinRequirements(color: Color, values: [Int]) -> [String] {
        return ["Place \(values[0]) winning bets on \(color.rawValue)", "Place \(values[1]) winning bets on \(color.rawValue)", "Place \(values[2]) winning bets on \(color.rawValue)"]
    }
    
    private func powerUpRequirements(powerUp: String, values: [Int]) -> [String] {
        return ["Use \(powerUp) \(values[0]) times", "Use \(powerUp) \(values[1]) times", "Use \(powerUp) \(values[2]) times"]
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