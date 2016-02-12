//
//  Board.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

import Foundation

let Columns = 3
let Rows = 2

class Board {
    private var squares = Array2D<Square>(columns: Columns, rows: Rows)
    
    func squareAtColumn(column: Int, row: Int) -> Square {
        assert(column >= 0 && column < Columns)
        assert(row >= 0 && row < Rows)
        
        return squares[column, row]!
    }
    
    func createGameBoard() -> Array2D<Square>{
        var colors = [Color.Blue, Color.Red, Color.Green, Color.Yellow, Color.Cyan, Color.Purple]
        
        var index = 0
        
        for row in 0..<Rows {
            for column in 0..<Columns {
                let square = Square(column: column, row: row, color: colors[index])
                
                squares[column, row] = square
                index++
            }
        }
        
        return squares
    }
    
    func clearWagers() {
        for row in 0..<Rows {
            for column in 0..<Columns {
                let square = squares[column, row]
                
                square?.wager = 0
            }
        }
        
        NSUserDefaults().wagers = 0
    }
    
    func getWagers() -> Int {
        var total = 0
        
        for row in 0..<Rows {
            for column in 0..<Columns {
                let square = squares[column, row]!
                
                total += square.wager
            }
        }
        
        return total
    }
}