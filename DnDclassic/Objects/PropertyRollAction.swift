//
//  PropertyRollAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 13/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class PropertyRollAction: Action {
    
    let properties: [CharacterProperty]
    let equalOrLess: WayPoint
    let greater: WayPoint
    let dice: Int
    
    required init?(json: JSON) {
        
        if let _dice = json[JSONkeys.dice] as? Int, _dice > 0 {
            dice = _dice
        }
        else {
            dice = 1
        }
        
        var _properties = [CharacterProperty]()
        guard let _proprtiesArray = json[JSONkeys.properties] as? [String] else {return nil}
        for propertyString in _proprtiesArray {
            guard let _propertyString = propertyString.nilIfEmpty, let _property = CharacterProperty(rawValue: _propertyString) else {return nil}
            _properties.append(_property)
        }
        guard !_properties.isEmpty else {return nil}
        properties = _properties
        
        guard let _greaterObject = json[JSONkeys.greater] as? JSON, let _greater = WayPoint(json: _greaterObject) else {return nil}
        greater = _greater
        
        guard let _equalOrLessObject = json[JSONkeys.equalOrLess] as? JSON, let _equalOrLess = WayPoint(json: _equalOrLessObject) else {return nil}
        equalOrLess = _equalOrLess
        
        super.init(json: json)
    }
        
    private struct JSONkeys {
        static let properties   = "properties"
        static let equalOrLess  = "equalOrLess"
        static let greater      = "greater"
        static let dice         = "dice"
    }
}
