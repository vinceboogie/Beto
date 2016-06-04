//
//  ThemeManager.swift
//  Beto
//
//  Created by Jem on 6/3/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

class ThemeManager {
    private(set) var themes = [Theme]()

    init() {
        let defaultTheme = Theme(themeName: "Default", unlocked: true)
        themes.append(defaultTheme)
        
        let blueTheme = Theme(themeName: "Blue", unlocked: Achievements.get(AchievementName.BlueWin).level == 3)
        themes.append(blueTheme)
        
        let redTheme = Theme(themeName: "Red", unlocked: Achievements.get(AchievementName.RedWin).level == 3)
        themes.append(redTheme)
        
        let greenTheme = Theme(themeName: "Green", unlocked: Achievements.get(AchievementName.GreenWin).level == 3)
        themes.append(greenTheme)
        
        let yellowTheme = Theme(themeName: "Yellow", unlocked: Achievements.get(AchievementName.YellowWin).level == 3)
        themes.append(yellowTheme)
        
        let cyanTheme = Theme(themeName: "Cyan", unlocked: Achievements.get(AchievementName.CyanWin).level == 3)
        themes.append(cyanTheme)
        
        let purpleTheme = Theme(themeName: "Purple", unlocked: Achievements.get(AchievementName.PurpleWin).level == 3)
        themes.append(purpleTheme)
        
        let blackTheme = Theme(themeName: "Black", unlocked: true)
        themes.append(blackTheme)
        
    }

    func getTheme(themeName: String) -> Theme {
        for theme in themes {
            if theme.name == themeName {
                return theme
            }
        }

        // Return default theme as failsafe. This could should never execute
        return themes[0]
    }
}