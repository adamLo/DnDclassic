//
//  KillBonus.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 28/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Bonus: Deserializable {
    
    let property: CharacterProperty
    let gain: Int?
    let resetDelta: Int?
    
    required init?(json: JSON) {
        
        guard let propertyString = json[JSONkeys.property] as? String, let _propertyString = propertyString.nilIfEmpty, let _property = CharacterProperty(rawValue: _propertyString) else {return nil}
        property = _property
        
        gain = json[JSONkeys.gain] as? Int
        resetDelta = json[JSONkeys.reset] as? Int
        
        guard !(gain == nil && resetDelta == nil) else {return nil}
    }
    
    private struct JSONkeys {
        static let property = "property"
        static let gain     = "gain"
        static let reset    = "reset"
    }
    
}
