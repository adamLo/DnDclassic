//
//  Sword.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 21/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Sword: Weapon {
    
    override var type: InventoryItemType {
        return .sword
    }
    
    override var description: String {
        return name?.nilIfEmpty ?? identifier ?? Localization.itemDescriptionSword
    }
    
    override func add(amount: Int) {
    }
}
