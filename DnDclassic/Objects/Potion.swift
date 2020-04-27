//
//  Potion.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Potion: InventoryItem {
    
    var identifier: String? {
        return "potion_\(type)"
    }
    
    let type: InventoryItemType = .potion
    
    let modifiedProperty: CharacterProperty?
    let modifierValue: Int? = 0
    let name: String? = nil
    let canUnEquip: Bool? = true
    let attackBonus: Int? = nil
    let autoEquip: Bool? = false
        
    var description: String {
        return String(format: Localization.itemDescriptionFormatPotion, modifiedProperty?.rawValue ?? "N/A", amount)
    }
    
    private(set) var amount: Int = 2
    
    let consumeWhenUsed: Bool? = true
    
    init(type: CharacterProperty) {
        
        self.modifiedProperty = type
    }
    
    func use(amount: Int) {
        
        self.amount = max(self.amount - amount, 0)
    }
        
    func add(amount: Int) {
        
    }
    
    func drop(amount: Int) {
        
        self.amount = max(self.amount - amount, 0)
    }
}
