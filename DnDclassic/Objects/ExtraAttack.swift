//
//  ExtraAttack.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 22/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct ExtraAttack: Deserializable {
    
    let dice: Int
    let choices: [ExtraAttackChoice]
    
    init?(json: JSON) {
        
        guard let _dice = json[JSONkeys.dice] as? Int, _dice > 0 else {return nil}
        dice = _dice
        
        guard let _choicesJson = json[JSONkeys.choices] as? JSONArray, _choicesJson.count >= _dice else {return nil}
        var _choices = [ExtraAttackChoice]()
        for json in _choicesJson {
            guard let _choice = ExtraAttackChoice(json: json) else {return nil}
            _choices.append(_choice)
        }
        guard _choices.count >= _dice else {return nil}
        choices = _choices
    }
    
    private struct JSONkeys {
        static let dice     = "dice"
        static let choices  = "choices"
    }
}
