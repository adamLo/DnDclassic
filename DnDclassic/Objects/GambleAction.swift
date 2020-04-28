//
//  GambleAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 19/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class GambleAction: Action {
    
    let opponentName: String
    let finish: WayPoint
    let winBonus: [Bonus]?
    let dice: Int
    
    required init?(json: JSON) {
        
        if let __opponent = json[JSONkeys.opponent] as? String, let _opponent = __opponent.nilIfEmpty {
            opponentName = _opponent
        }
        else {
            opponentName = Strings.opponent
        }
        
        guard let _finishObject = json[JSONkeys.finish] as? JSON, let _finish = WayPoint(json: _finishObject) else {return nil}
        finish = _finish
        
        var _bonuses = [Bonus]()
        if let _bonusArray = json[JSONkeys.winBonus] as? JSONArray {
            for _bonusObject in _bonusArray {
                guard let _bonus = Bonus(json: _bonusObject) else {return nil}
                _bonuses.append(_bonus)
            }
        }
        if !_bonuses.isEmpty {
            winBonus = _bonuses
        }
        else {
            winBonus = nil
        }
        
        guard let _dice = json[JSONkeys.dice] as? Int, _dice > 0 else {return nil}
        dice = _dice
        
        super.init(json: json)
    }
    
    private struct JSONkeys {
        static let opponent = "opponent"
        static let finish   = "finish"
        static let winBonus = "winBonus"
        static let dice     = "dice"
    }
}
