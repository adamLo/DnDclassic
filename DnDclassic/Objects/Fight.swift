//
//  Fight.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Fight {
    
    let player: Character
    let opponent: Opponent
    
    private(set) var rounds = 0
    private var opponentDamageRoundCount = 0
    private var playerDamageRoundCount = 0
    
    var opponentDamageEvent: ((_ waypoint: WayPoint) -> ())?
    var playerDamageEvent: ((_ waypoint: WayPoint) -> ())?
    var eventOccured: ((_ waypoint: WayPoint) -> ())?
    
    init(player: Character, opponent: Opponent) {
        
        self.player = player
        self.opponent = opponent
    }
    
    @discardableResult
    func performRound(playerRoll: Int? = nil, opponentRoll: Int? = nil, withLuck: Bool? = nil) -> (playerDamage: Int, opponentDamage: Int) {
        
        guard player.health > 0, opponent.health > 0 else {return (0,0)}
        
        rounds += 1
        
        let opponentAttack = (opponentRoll ?? Dice(number: 2).roll()) + opponent.dexterity
        var playerAttack = (playerRoll ?? Dice(number: 2).roll()) + player.dexterity + (opponent.playerRollBonus ?? 0)
        
        if let _damagedBy = opponent.damagedBy, !player.hasInventoryItem(of: _damagedBy) {
            // When opponent can be damaged only by specific type of item and player doesn't own any of it
            playerAttack = 0
        }
        
        var damage = 2
        var playerDamage = 0
        var opponentDamage = 0
        
        player.log(event: .fight(opponent: opponent.name, playerAttack: playerAttack, opponentAttack: opponentAttack))
                        
        if playerAttack > opponentAttack {
            
            if let _damage = opponent.hitDamage {
                damage = _damage
            }
            else if let _luck = withLuck {
                damage += _luck ? 2 : -1
            }
            opponent.hitDamage(points: damage)
            
            if opponent.isDead {
                if let bonus = opponent.killBonus {
                    player.apply(bonus: bonus)
                }
                opponent.log(event: .died)
                player.log(event: .kill(opponent: opponent.name))
            }
            else {
                opponentDamageRoundCount += 1
                if let _damageEvent = opponent.damageEvent, _damageEvent.round == opponentDamageRoundCount {
                    opponentDamageEvent?(_damageEvent.waypoint)
                }
            }
            
            opponentDamage = damage
        }
        else if opponentAttack > playerAttack {
            
            if let damageRoll = opponent.playerDamageRoll {
                let roll = Dice(number: damageRoll.dice).roll()
                player.log(event: .roll(value: roll))
                damage = damageRoll.choices[roll] ?? 0
            }
            else if let _luck = withLuck {
                damage += _luck ? 1 : -1
            }
            player.hitDamage(points: damage)
            
            if let _bonus = opponent.hitBonus, (rounds % _bonus.round == 0) {
                player.apply(bonus: _bonus)
            }
            
            if player.isDead {
                player.log(event: .died)
            }
            else {
                
                playerDamageRoundCount += 1
                if let damageEvent = opponent.playerDamageEvent, playerDamageRoundCount == damageEvent.round {
                    playerDamageEvent?(damageEvent.waypoint)
                }
            }
            
            playerDamage = damage
        }
        
        if !player.isDead, !opponent.isDead, let event = opponent.event, event.round == rounds {
            eventOccured?(event.waypoint)
        }
        
        return (playerDamage, opponentDamage)
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
        return player.health <= 0 || opponent.health <= 0
    }
    
    var hasUserWon: Bool {
        guard isFinished else {return false}
        return player.health > opponent.health
    }
    
    var canTryLuck: Bool {
        
        if opponent.playerRollBonus != nil || opponent.playerDamageRoll != nil {
            return false
        }
        return true
    }
}
