//
//  Gamble.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 19/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Gamble {
    
    let action: GambleAction
    let player: Character
    
    private(set) var rounds: Int = 0
    
    init(action: GambleAction, player: Character) {
        
        self.action = action
        self.player = player
    }
    
    func roll() -> (playerRoll: Int, opponentRoll: Int, win: Bool) {
        
        let dice = Dice(number: action.dice)
        
        let playerRoll = dice.roll()
        let opponentRoll = dice.roll()
        
        rounds += 1
        
        return (playerRoll: playerRoll, opponentRoll: opponentRoll, win: playerRoll > opponentRoll)
    }
}
