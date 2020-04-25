//
//  TryLuckAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 08/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class TryLuckAction: Action {
    
    let goodLuck: WayPoint
    let badLuck: WayPoint
    /// If true, roll is a win of money
    let rollWinsMoney: Bool
    let rollLoseMoney: Bool
    let badLuckRolls: [RollChoice]?
    let goodLuckRolls: [RollChoice]?
    
    required init?(json: JSON) {

        guard let _goodLuckJson = json[JSONkeys.goodLuck] as? JSON, let _goodLuck = WayPoint(json: _goodLuckJson) else {return nil}
        goodLuck = _goodLuck
        
        guard let _badLuckJson = json[JSONkeys.badLuck] as? JSON, let _badLuck = WayPoint(json: _badLuckJson) else {return nil}
        badLuck = _badLuck
        
        rollWinsMoney = json[JSONkeys.rollWinsMoney] as? Bool ?? false
        rollLoseMoney = json[JSONkeys.rollLoseMoney] as? Bool ?? false
        
        if let rollsJson = _badLuckJson[JSONkeys.rolls] as? JSONArray {
            var _choices = [RollChoice]()
            for choiceJson in rollsJson {
                guard let _choice = RollChoice(json: choiceJson) else {return nil}
                _choices.append(_choice)
            }
            guard !_choices.isEmpty else {return nil}
            badLuckRolls = _choices
        }
        else {
            badLuckRolls = nil
        }
        
        if let rollsJson = _goodLuckJson[JSONkeys.rolls] as? JSONArray {
            var _choices = [RollChoice]()
            for choiceJson in rollsJson {
                guard let _choice = RollChoice(json: choiceJson) else {return nil}
                _choices.append(_choice)
            }
            guard !_choices.isEmpty else {return nil}
            goodLuckRolls = _choices
        }
        else {
            goodLuckRolls = nil
        }
        
        super.init(json: json)
    }
    
    private struct JSONkeys {
        static let goodLuck         = "goodLuck"
        static let badLuck          = "badLuck"
        static let rollWinsMoney    = "rollWinsMoney"
        static let rollLoseMoney    = "rollLoseMoney"
        static let rolls            = "rolls"
    }
}
