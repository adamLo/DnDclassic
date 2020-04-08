//
//  InventoryObject.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class InventoryObject: InventoryItem {
    
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
        default: return nil
        }
    }
}
