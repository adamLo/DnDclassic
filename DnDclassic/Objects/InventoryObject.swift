//
//  InventoryObject.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct InventoryObject: InventoryItem {
    
    var description: String {
        return "\(name) (\(type.rawValue))"
    }
        
    let type: InventoryItemType
    let name: String
    
    let modifiesPropertyWhenEquipped: CharacterProperty?
    let modifierValueWhenEquipped: Int?
        
    let modifiesPropertyWhenUsed: CharacterProperty?
    let modiferValueWhenUsed: Int?

    let identifier: Any?
    
    let amount: Int = 1
    
    init(type: InventoryItemType, name: String,
         modifiesPropertyWhenEquipped: CharacterProperty? = nil, modifierValueWhenEquipped: Int? = 0,
         modifiesPropertyWhenUsed: CharacterProperty? = nil, modiferValueWhenUsed: Int? = 0,
         identifier: Any? = nil
    ) {
        
        self.type = type
        self.name = name
        
        self.modifiesPropertyWhenEquipped = modifiesPropertyWhenEquipped
        self.modifierValueWhenEquipped = modifierValueWhenEquipped ?? 0
        
        self.modifiesPropertyWhenUsed = modifiesPropertyWhenUsed
        self.modiferValueWhenUsed = modiferValueWhenUsed ?? 0
        
        self.identifier = identifier
    }
}
