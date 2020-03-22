//
//  FightAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 21/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

enum FightOrder: String {
    case single
}

class FightAction: Action {
    
    let order: FightOrder
    let opponents: [Opponent]
    let escape: WayPoint
    let win: WayPoint
    
    required init?(json: JSON) {

        if let _orderString = json[JSONKeys.order] as? String, let _order = FightOrder(rawValue: _orderString) {
            order = _order
        }
        else {
            order = .single
        }
        
        guard let _winObject = json[JSONKeys.win] as? JSON, let _win = WayPoint(json: _winObject) else {return nil}
        win = _win
        
        guard let _escapeObject = json[JSONKeys.escape] as? JSON, let _escape = WayPoint(json: _escapeObject) else {return nil}
        escape = _escape
        
        guard let _opponentObjects = json[JSONKeys.opponents] as? JSONArray else {return nil}
        var _opponents = [Opponent]()
        for object in _opponentObjects {
            guard let opponent = Opponent(json: object) else {return nil}
            _opponents.append(opponent)
        }
        opponents = _opponents
        
        super.init(json: json)
    }
    
    private struct JSONKeys {
        static let opponents    = "opponents"
        static let escape       = "escape"
        static let win          = "win"
        static let order        = "order"
    }
    
    var isOver: Bool {
        
        for opponent in opponents {
            if !opponent.isDead {
                return false
            }
        }
        
        return true
    }
}
