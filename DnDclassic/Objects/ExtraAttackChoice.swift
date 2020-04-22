//
//  ExtraAttackChoice.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 22/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct ExtraAttackChoice: Deserializable {
    
    let roll: Int
    let caption: String?
    let canUseLuck: Bool?
    let effects: [Bonus]?
    
    init?(json: JSON) {
        
        guard let _roll = json[JSONkeys.roll] as? Int, _roll > 0 else {return nil}
        roll = _roll
        
        caption = json[JSONkeys.caption] as? String
        canUseLuck = json[JSONkeys.canUseLuck] as? Bool
        
        var _effects = [Bonus]()
        if let _effectsJson = json[JSONkeys.effects] as? JSONArray {
            for json in _effectsJson {
                guard let effect = Bonus(json: json) else {return nil}
                _effects.append(effect)
            }
            guard !_effects.isEmpty else {return nil}
            effects = _effects
        }
        else {
            effects = nil
        }
    }
    
    private struct JSONkeys {
        static let roll         = "roll"
        static let caption      = "caption"
        static let canUseLuck   = "canUseLuck"
        static let effects      = "effects"
    }
}
