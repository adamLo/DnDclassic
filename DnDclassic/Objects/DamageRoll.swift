//
//  DamageRoll.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 11/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct DamageRoll: Deserializable {
    
    let choices: [Int: Int]
    let dice: Int
    
    init?(json: JSON) {
        
        guard let _dice = json[JSONkeys.dice] as? Int else {return nil}
        dice = _dice
        
        guard let _choicesArray = json[JSONkeys.choices] as? JSONArray else {return nil}
        var _choices = [Int: Int]()
        for _choice in _choicesArray {
            guard let roll = _choice[JSONkeys.roll] as? Int, let damage = _choice[JSONkeys.damage] as? Int else {return nil}
            _choices[roll] = damage
        }
        guard !_choices.isEmpty else {return nil}
        choices = _choices
    }
    
    private struct JSONkeys {
        static let dice     = "dice"
        static let choices  = "choices"
        static let roll     = "roll"
        static let damage   = "damage"
    }
}
