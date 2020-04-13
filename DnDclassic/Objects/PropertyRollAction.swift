//
//  PropertyRollAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 13/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class PropertyRollAction: Action {
    
    let property: CharacterProperty
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
        
        guard let __propertyString = json[JSONkeys.property] as? String, let _propertyString = __propertyString.nilIfEmpty, let _property = CharacterProperty(rawValue: _propertyString) else {return nil}
        property = _property
        
        guard let _greaterObject = json[JSONkeys.greater] as? JSON, let _greater = WayPoint(json: _greaterObject) else {return nil}
        greater = _greater
        
        guard let _equalOrLessObject = json[JSONkeys.equalOrLess] as? JSON, let _equalOrLess = WayPoint(json: _equalOrLessObject) else {return nil}
        equalOrLess = _equalOrLess
        
        super.init(json: json)
    }
        
    private struct JSONkeys {
        static let property     = "property"
        static let equalOrLess  = "equalOrLess"
        static let greater      = "greater"
        static let dice         = "dice"
    }
}
