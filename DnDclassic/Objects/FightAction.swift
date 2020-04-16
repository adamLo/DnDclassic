//
//  FightAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 21/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

enum FightOrder: String {
    case single, random
}

class FightAction: Action {
    
    let order: FightOrder
    let opponents: [Opponent]
    let escape: WayPoint?
    let win: WayPoint?
    let escapeDamage: Int?
    let escapeAvailableInRound: Int?
    
    required init?(json: JSON) {

        if let _orderString = json[JSONkeys.order] as? String, let _order = FightOrder(rawValue: _orderString) {
            order = _order
        }
        else {
            order = .random
        }
        
        if let _winObject = json[JSONkeys.win] as? JSON, let _win = WayPoint(json: _winObject) {
            win = _win
        }
        else {
            win = nil
        }
        
        if let _escapeObject = json[JSONkeys.escape] as? JSON, let _escape = WayPoint(json: _escapeObject) {
            escape = _escape
            escapeAvailableInRound = _escapeObject[JSONkeys.availableRound] as? Int
        }
        else {
            escape = nil
            escapeAvailableInRound = nil
        }
        
        guard let _opponentObjects = json[JSONkeys.opponents] as? JSONArray else {return nil}
        var _opponents = [Opponent]()
        for object in _opponentObjects {
            guard let opponent = Opponent(json: object) else {return nil}
            _opponents.append(opponent)
        }
        opponents = _opponents
        
        escapeDamage = json[JSONkeys.escapeDamage] as? Int
        
        super.init(json: json)
    }
    
    private struct JSONkeys {
        static let opponents        = "opponents"
        static let escape           = "escape"
        static let win              = "win"
        static let order            = "order"
        static let escapeDamage     = "escapeDamage"
        static let availableRound   = "availableRound"
    }
    
    var isOver: Bool {
        
        for opponent in opponents {
            if !opponent.isDead {
                return false
            }
        }
        
        return true
    }

    var currentOpponent: Opponent? {
        
        let aliveOpponents = opponents.filter { (opponent) -> Bool in
            return !opponent.isDead
        }
        let orderedAliveOpponents = aliveOpponents.sorted { (opponent1, opponent2) -> Bool in
            return opponent1.order <= opponent2.order
        }
        return orderedAliveOpponents.first
    }
}
