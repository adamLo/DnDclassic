//
//  InventoryItem.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

enum InventoryItemType: String {
    
    case weapon, armor, key, lighting, money, food, potion, silverWeapon, hammer, shield
    
    var equippable: Bool {
        return [InventoryItemType.weapon, InventoryItemType.armor, InventoryItemType.silverWeapon, InventoryItemType.shield].contains(self)
    }
    
    func canEquipWithOther(type: InventoryItemType) -> Bool {
        
        if self == .weapon && [InventoryItemType.weapon, InventoryItemType.silverWeapon].contains(type) {
            return false
        }
        if self == .armor, type == .armor {
            return false
        }
        if self == .shield, type == .shield {
            return false
        }
        
        return true
    }
}

protocol InventoryItem: CustomStringConvertible {
    
    var identifier: String? {get}
    
    var type: InventoryItemType {get}
    
    var modifiedProperty: CharacterProperty? {get}
    var modifierValue: Int? {get}
    
    var amount: Int {get}
    
    func use(amount: Int)
    func add(amount: Int)
    
    var name: String? {get}
    
    var consumeWhenUsed: Bool? {get}
}

