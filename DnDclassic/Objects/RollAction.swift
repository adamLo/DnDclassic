//
//  RollAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 25/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class RollAction: Action {
    
    let dice: Int
    let choices: [RollChoice]
    
    required init?(json: JSON) {
        
        guard let _dice = json[JSONkeys.dice] as? Int else {return nil}
        dice = _dice
        
        guard let _choicesArray = json[JSONkeys.choices] as? JSONArray else {return nil}
        var _choices = [RollChoice]()
        for _choiceJson in _choicesArray {
            guard let _choice = RollChoice(json: _choiceJson) else {return nil}
            _choices.append(_choice)
        }
        guard !_choices.isEmpty else {return nil}
        choices = _choices
        
        super.init(json: json)
    }
    
    private struct JSONkeys {
        static let dice = "dice"
        static let choices = "choices"
    }
}
