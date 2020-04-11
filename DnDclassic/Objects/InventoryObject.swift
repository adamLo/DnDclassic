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
        return "\(name ?? "N/A") (\(type.rawValue))"
    }
        
    let type: InventoryItemType
    let name: String?
    
    let modifiedProperty: CharacterProperty?
    let modifierValue: Int?
        
    let identifier: Any?
    
    let amount: Int
    
    init(type: InventoryItemType, name: String,
         modifiedProperty: CharacterProperty? = nil, modifierValue: Int? = 0,         
         identifier: Any? = nil
    ) {
        
        self.type = type
        self.name = name
        
        self.modifiedProperty = modifiedProperty
        self.modifierValue = modifierValue ?? 0
                
        self.identifier = identifier
        self.amount = 1
    }
    
    func use(amount: Int) {
    }
    
    func add(amount: Int) {
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
        
        identifier = json[JSONKeys.id]
        
        amount = json[InventoryObject.JSONKeys.amount] as? Int ?? 1
    }
    
    // MARK: - JSON
        
    struct JSONKeys {
        static let amount           = "amount"
        static let type             = "type"
        static let modifiedProperty = "modifiedProperty"
        static let modifierValue    = "modifierValue"
        static let id               = "id"
        static let name             = "name"
    }
}

class InventoryItemFactory {
    
    class func item(json: JSON) -> InventoryItem? {
        
        guard let _typeString = json[InventoryObject.JSONKeys.type] as? String, let type = InventoryItemType(rawValue: _typeString) else {return nil}
        
        switch type {
        case .money: return Money(json: json)
        case .weapon: return Weapon(json: json)
        default: return InventoryObject(json: json)
        }
    }
}
