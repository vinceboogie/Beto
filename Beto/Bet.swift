//
//  Bet.swift
//  Beto
//
//  Created by Jem on 2/4/16.
//  Copyright © 2016 redgarage. All rights reserved.
//

struct Bet: CustomStringConvertible {
//    enum BetAmount: Int, CustomStringConvertible {
//        case One, Five, Ten, Fifty, Hundred
//        
//        var betAmount: Int {
//            let betAmounts = [1, 5, 10, 50, 100]
//            
//            return betAmounts[rawValue]
//        }
//        
//        var description: String {
//            return "current betAmount: \(betAmount)"
//        }
//        
//    }
    
    let square: Square
    let betValue: Int
    
    init(square: Square, betValue: Int) {
        self.square = square
        self.betValue = betValue
    }
    
    var description: String {
        return "placed \(betValue) on \(square.color)"
    }
    
    func placeBet() {            
        square.wager += betValue
    }
}