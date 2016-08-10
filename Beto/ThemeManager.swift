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
        let defaultTheme = Theme(themeName: "Default")
        themes.append(defaultTheme)
        
        let blueTheme = Theme(themeName: "Blue")
        blueTheme.setPrice(.Basic)
        themes.append(blueTheme)
        
        let redTheme = Theme(themeName: "Red")
        redTheme.setPrice(.Basic)
        themes.append(redTheme)
        
        let greenTheme = Theme(themeName: "Green")
        greenTheme.setPrice(.Basic)
        themes.append(greenTheme)
        
        let purpleTheme = Theme(themeName: "Purple")
        purpleTheme.setPrice(.Basic)
        themes.append(purpleTheme)
        
        let yellowTheme = Theme(themeName: "Yellow")
        yellowTheme.setPrice(.Premium)
        themes.append(yellowTheme)
        
        let cyanTheme = Theme(themeName: "Cyan")
        cyanTheme.setPrice(.Premium)
        themes.append(cyanTheme)
        
        let blackTheme = Theme(themeName: "Black")
        blackTheme.setPrice(.Premium)
        themes.append(blackTheme)
        
        let azulTheme = Theme(themeName: "Azul")
        azulTheme.setPrice(ThemePrice.Legendary)
        themes.append(azulTheme)
        
        let midnightTheme = Theme(themeName: "Midnight")
        midnightTheme.setPrice(ThemePrice.Legendary)
        themes.append(midnightTheme)
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