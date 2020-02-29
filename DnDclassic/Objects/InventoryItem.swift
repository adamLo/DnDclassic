//
//  InventoryItem.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

enum InventoryItemType: String {
    
    case weapon, armor, key, lighting, money, food, potion
}

protocol InventoryItem: CustomStringConvertible {
    
    var identifier: Any? {get}
    
    var type: InventoryItemType {get}
    
    var modifiesPropertyWhenEquipped: CharacterProperty? {get}
    var modifierValueWhenEquipped: Int? {get}
    
    var modifiesPropertyWhenUsed: CharacterProperty? {get}
    var modiferValueWhenUsed: Int? {get}
    
    var amount: Int {get}
}

