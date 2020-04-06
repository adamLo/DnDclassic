//
//  Potion.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Potion: InventoryItem {
    
    var identifier: Any? {
        return "potion_\(type)"
    }
    
    let type: InventoryItemType = .potion
    
    let modifiesPropertyWhenEquipped: CharacterProperty? = nil
    let modifierValueWhenEquipped: Int? = 0
    let modifiesPropertyWhenUsed: CharacterProperty?
    let modiferValueWhenUsed: Int? = nil
    let name: String? = nil
    
    var description: String {
        return String(format: NSLocalizedString("Potion of %@ (rations: %d)", comment: "Potion name format"), modifiesPropertyWhenUsed?.rawValue ?? "N/A", amount)
    }
    
    private(set) var amount: Int = 2
    
    init(type: CharacterProperty) {
        
        self.modifiesPropertyWhenUsed = type
    }
    
    func use(amount: Int) {
        self.amount = max(self.amount - amount, 0)
    }
        
    func add(amount: Int) {
    }
}
