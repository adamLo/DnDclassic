//
//  Fight.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct Fight {
    
    let player: Player
    let opponent: Player
    
    init(player: Player, opponent: Player) {
        
        self.player = player
        self.opponent = opponent
    }
    
    @discardableResult
    func performRound(playerRoll: Int? = nil, opponentRoll: Int? = nil, withLuck: Bool? = nil) -> (playerHit: Int, opponentHit: Int) {
        
        guard player.healthCurrent > 0, opponent.healthCurrent > 0 else {return (0,0)}
        
        let opponentAttack = (opponentRoll ?? Dice(number: 2).roll()) + opponent.dexterityCurrenty
        let playerAttack = (playerRoll ?? Dice(number: 2).roll()) + player.dexterityCurrenty
        
        var damage = 2
                
        if playerAttack > opponentAttack {
            if let _luck = withLuck {
                damage += _luck ? 2 : -1
            }
            opponent.hitDamage(points: damage)
            return (damage, 0)
        }
        else if opponentAttack > playerAttack {
            if let _luck = withLuck {
                damage += _luck ? 1 : -1
            }
            player.hitDamage(points: damage)
            return (0, damage)
        }
        else {
            return (0,0)
        }
    }
    
    @discardableResult
    func runAway(withLuck: Bool? = nil) -> Int {
        
        var damage = -2
        if let _luck = withLuck {
            damage += _luck ? -1 : 1
        }
        
        player.hitDamage(points: damage)
        
        return damage
    }
    
    var isFinished: Bool {
        return player.healthCurrent <= 0 || opponent.healthCurrent <= 0
    }
    
    var hasUserWon: Bool {
        guard isFinished else {return false}
        return player.healthCurrent > opponent.healthCurrent
    }
}
