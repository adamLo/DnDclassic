//
//  InventoryItem.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

enum InventoryItemType: String {
    
    case weapon, armor, key, lamp
}

struct InventoryItem {
    
    let type: InventoryItemType
    let name: String
    
    let modifiesPropertyWhenEquipped: CharacterProperty?
    let modifierValueWhenEquipped: Int
    
    let modifiesPropertyWhenUsed: CharacterProperty?
    let modiferValueWhenUsed: Int
    
    let identifier: Any?
    
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
