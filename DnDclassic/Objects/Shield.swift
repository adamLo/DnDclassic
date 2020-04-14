//
//  Shield.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 14/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Shield: InventoryItem, Deserializable {
    
    let identifier: String?
    let type: InventoryItemType = .shield
    let amount: Int = 1
    let name: String?
    let modifiedProperty: CharacterProperty?
    let modifierValue: Int?
    var consumeWhenUsed: Bool? {
        return false
    }
        
    var description: String {
        return name?.nilIfEmpty ?? identifier ?? NSLocalizedString("Shield", comment: "Shield title")
    }
    
    // MARK: - JSON
    
    required init?(json: JSON) {
        
        identifier = json[InventoryObject.JSONKeys.id] as? String
        
        if let propertyString = json[InventoryObject.JSONKeys.modifiedProperty] as? String, let _propertyString = propertyString.nilIfEmpty, let _property = CharacterProperty(rawValue: _propertyString), let _value = json[InventoryObject.JSONKeys.modifierValue] as? Int {
            modifiedProperty = _property
            modifierValue = _value
        }
        else {
            modifiedProperty = nil
            modifierValue = nil
        }
        
        name = json[InventoryObject.JSONKeys.name] as? String
    }
    
    func use(amount: Int) {
    }
    
    func add(amount: Int) {
    }
    
    /// Damage modifier for special items
    func modifedDamage(_ original: Int) -> Int {
        
        if let _name = name, _name == "shield_golden_crescent" {
            // Custom code for the Shield with a Golden Crescent on scene 155
            if Dice(number: 1).roll() == 6 {
                if original == 2 {
                    return 1
                }
                if original == 1 {
                    return 0
                }
            }
        }
        
        return original
    }
}
