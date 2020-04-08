//
//  Weapon.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 06/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct Weapon: InventoryItem, Deserializable {
    
    let identifier: Any?
    let type: InventoryItemType = .weapon
    let amount = 1
    let name: String?
    let modifiedProperty: CharacterProperty?
    let modifierValue: Int?
        
    var description: String {
        return name?.nilIfEmpty ?? identifier as? String ?? NSLocalizedString("Weapon", comment: "Weapon title")
    }
    
    // MARK: - JSON
    
    init?(json: JSON) {
        
        identifier = json[InventoryObject.JSONKeys.id]
        
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
}
