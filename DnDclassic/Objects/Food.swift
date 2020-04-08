//
//  Food.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Food: InventoryItem {
    
    let identifier: Any? = "food"
    let type: InventoryItemType = .food
    let modifiedProperty: CharacterProperty? = nil
    let modifierValue: Int? = nil
    let name: String? = nil
        
    var amount: Int
    
    init(amount: Int) {
        self.amount = amount
    }
    
    var description: String {
        return String(format: NSLocalizedString("Food (rations: %d)", comment: "Food description format"), amount)
    }
    
    @discardableResult func eat() -> Bool {
        
        guard amount > 0 else {return false}
        
        amount -= 1
        return true
    }
    
    func use(amount: Int) {
        
        self.amount = max(self.amount - amount, 0)
    }
    
    func add(amount: Int) {
        
        self.amount += amount
    }
}
