//
//  KillBonus.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 28/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct KillBonus: Deserializable {
    
    let property: CharacterProperty
    let gain: Int
    
    init?(json: JSON) {
        
        guard let propertyString = json[JSONkeys.property] as? String, let _propertyString = propertyString.nilIfEmpty, let _property = CharacterProperty(rawValue: _propertyString) else {return nil}
        property = _property
        
        guard let _gain = json[JSONkeys.gain] as? Int else {return nil}
        gain = _gain
    }
    
    private struct JSONkeys {
        static let property = "property"
        static let gain     = "gain"
    }
    
}
