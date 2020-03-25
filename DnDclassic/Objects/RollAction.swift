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
        
        guard let _dice = json[JSONKeys.dice] as? Int else {return nil}
        dice = _dice
        
        guard let _choicesArray = json[JSONKeys.choices] as? JSONArray else {return nil}
        var _choices = [RollChoice]()
        for _choiceJson in _choicesArray {
            guard let _choice = RollChoice(json: _choiceJson) else {return nil}
            _choices.append(_choice)
        }
        guard !_choices.isEmpty else {return nil}
        choices = _choices
        
        super.init(json: json)
    }
    
    private struct JSONKeys {
        static let dice = "dice"
        static let choices = "choices"
    }
}
