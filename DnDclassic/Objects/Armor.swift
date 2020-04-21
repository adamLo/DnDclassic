//
//  Armor.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 21/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Armor: InventoryItem {
    
    let identifier: String?
    private(set) var type: InventoryItemType = .armor
    private(set) var amount: Int = 1
    let name: String?
    let modifiedProperty: CharacterProperty?
    let modifierValue: Int?
    var consumeWhenUsed: Bool? {
        return false
    }
    let canUnEquip: Bool?
    let attackBonus: Int?
    let autoEquip: Bool?
        
    var description: String {
        return name?.nilIfEmpty ?? identifier ?? NSLocalizedString("Armor", comment: "Armor title")
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
        
        canUnEquip = json[InventoryObject.JSONKeys.canUnEquip] as? Bool ?? true
        attackBonus = json[InventoryObject.JSONKeys.attackBonus] as? Int
        autoEquip = json[InventoryObject.JSONKeys.autoEquip] as? Bool
    }
    
    // MARK: - Inventory Item
    
    func use(amount: Int) {
    }
    
    func add(amount: Int) {
    }
    
    func drop(amount: Int) {
        
        self.amount = max(self.amount - amount, 0)
    }
}
