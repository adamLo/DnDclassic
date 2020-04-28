//
//  Food.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Food: InventoryObject {
    
    override var type: InventoryItemType {
        return .food
    }
        
    override var consumeWhenUsed: Bool? {
        return true
    }
    
    init(amount: Int) {
        
        super.init(type: .food, name: Strings.itemDescriptionFood)
        self.amount = amount
    }
    
    required init?(json: JSON) {
        
        super.init(json: json)
    }
    
    override var description: String {
        return String(format: Strings.itemDescriptionFormatFood, amount)
    }
    
    @discardableResult func eat() -> Bool {
        
        guard amount > 0 else {return false}
        
        amount -= 1
        return true
    }
    
    override func use(amount: Int) {
    }
}
