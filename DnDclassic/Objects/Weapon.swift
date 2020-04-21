//
//  Weapon.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 06/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Weapon: InventoryItem, Deserializable {
    
    let identifier: String?
    let type: InventoryItemType = .weapon
    private (set) var amount: Int
    let name: String?
    let modifiedProperty: CharacterProperty?
    let modifierValue: Int?
    let consumeWhenUsed: Bool?
    let canUnEquip: Bool?
    let attackBonus: Int?
    let autoEquip: Bool?
        
    var description: String {
        return name?.nilIfEmpty ?? identifier ?? NSLocalizedString("Weapon", comment: "Weapon title")
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
        
        amount = json[InventoryObject.JSONKeys.amount] as? Int ?? 1
        
        consumeWhenUsed = json[InventoryObject.JSONKeys.consumeWhenUsed] as? Bool
        canUnEquip = json[InventoryObject.JSONKeys.canUnEquip] as? Bool ?? true
        attackBonus = json[InventoryObject.JSONKeys.attackBonus] as? Int
        autoEquip = json[InventoryObject.JSONKeys.autoEquip] as? Bool
    }
    
    func use(amount: Int) {
        
        if consumeWhenUsed ?? false {
            self.amount = max(self.amount - amount, 0)
        }
    }
    
    func add(amount: Int) {
        
        self.amount += amount
    }
    
    func drop(amount: Int) {
        
        self.amount = max(self.amount - amount, 0)
    }
}
