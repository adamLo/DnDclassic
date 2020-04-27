//
//  Weapon.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 06/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Weapon: InventoryObject {
    
    override var type: InventoryItemType {
        return .weapon
    }
        
    required init?(json: JSON) {
        
        super.init(json: json)
    }
    
    override var description: String {
        return name?.nilIfEmpty ?? identifier ?? Localization.itemDescriptionWeapon
    }
        
    override func use(amount: Int) {
    }
    
}
