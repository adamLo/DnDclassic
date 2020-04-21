//
//  Shield.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 14/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Shield: Armor {
    
    override var type: InventoryItemType {
        return .shield
    }
        
    override var description: String {
        return name?.nilIfEmpty ?? identifier ?? NSLocalizedString("Shield", comment: "Shield title")
    }
    
    /// Damage modifier for special items
    func modifedDamage(_ original: Int) -> Int {
        
        if let _name = name, _name == "shield_golden_crescent" {
            // Custom code for the Shield with a Golden Crescent on scene 155
            if Dice(number: 1).roll() == 6 {
                if original == 2 {
                    return 1
                }
                if original == 1 {
                    return 0
                }
            }
        }
        
        return original
    }
}
