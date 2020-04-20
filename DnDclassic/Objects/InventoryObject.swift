//
//  InventoryObject.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class InventoryObject: InventoryItem, Deserializable {
    
    var description: String {
        return "\(self.name ?? "N/A") (\(self.type.rawValue))"
    }
        
    let type: InventoryItemType
    let name: String?
    
    let modifiedProperty: CharacterProperty?
    let modifierValue: Int?
        
    let identifier: String?
    
    private(set) var amount: Int = 1
    
    let consumeWhenUsed: Bool?
    
    let canUnEquip: Bool?
    let attackBonus: Int?
    let autoEquip: Bool?
        
    init(type: InventoryItemType, name: String,
         modifiedProperty: CharacterProperty? = nil, modifierValue: Int? = 0,         
         identifier: String? = nil, consumeWhenUsed: Bool? = nil
    ) {
        
        self.type = type
        self.name = name
        
        self.modifiedProperty = modifiedProperty
        self.modifierValue = modifierValue ?? 0
                
        self.identifier = identifier
        
        self.consumeWhenUsed = consumeWhenUsed
        
        canUnEquip = true
        attackBonus = nil
        autoEquip = nil
    }
    
    func use(amount: Int) {
        
        if consumeWhenUsed ?? false {
            self.amount = max(self.amount - amount, 0)
        }
    }
    
    func add(amount: Int) {
        
        self.amount += amount
    }
    
    required init?(json: JSON) {
        
        guard let _typeString = json[InventoryObject.JSONKeys.type] as? String, let _type = InventoryItemType(rawValue: _typeString) else {return nil}
        type = _type
        
        name = json[JSONKeys.name] as? String
        
        if let propertyString = json[InventoryObject.JSONKeys.modifiedProperty] as? String, let _propertyString = propertyString.nilIfEmpty, let _property = CharacterProperty(rawValue: _propertyString), let _value = json[InventoryObject.JSONKeys.modifierValue] as? Int {
            modifiedProperty = _property
            modifierValue = _value
        }
        else {
            modifiedProperty = nil
            modifierValue = nil
        }
        
        identifier = json[JSONKeys.id] as? String
        
        amount = json[JSONKeys.amount] as? Int ?? 1
        
        consumeWhenUsed = json[JSONKeys.consumeWhenUsed] as? Bool
        
        canUnEquip = json[JSONKeys.canUnEquip] as? Bool ?? true
        attackBonus = json[JSONKeys.attackBonus] as? Int
        autoEquip = json[JSONKeys.autoEquip] as? Bool
    }
    
    // MARK: - JSON
        
    struct JSONKeys {
        static let amount           = "amount"
        static let type             = "type"
        static let modifiedProperty = "modifiedProperty"
        static let modifierValue    = "modifierValue"
        static let id               = "id"
        static let name             = "name"
        static let consumeWhenUsed  = "consumeWhenUsed"
        static let autoEquip        = "autoEquip"
        static let canUnEquip       = "canUnEquip"
        static let attackBonus      = "attackBonus"
    }
}

class InventoryItemFactory {
    
    class func item(json: JSON) -> InventoryItem? {
        
        guard let _typeString = json[InventoryObject.JSONKeys.type] as? String, let type = InventoryItemType(rawValue: _typeString) else {return nil}
        
        switch type {
        case .money: return Money(json: json)
        case .weapon: return Weapon(json: json)
        case .shield: return Shield(json: json)
        case .helmet: return Helmet(json: json)
        default: return InventoryObject(json: json)
        }
    }
}
