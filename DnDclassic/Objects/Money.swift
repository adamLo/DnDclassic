//
//  Money.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Money: InventoryObject {
    
    override var type: InventoryItemType {
        return .money
    }
        
    override var consumeWhenUsed: Bool? {
        return true
    }
    
    init(amount: Int) {
        
        super.init(type: .food, name: NSLocalizedString("Food", comment: "Food title"))
        self.amount = amount
    }
    
    required init?(json: JSON) {
        
        super.init(json: json)
    }
    
    override var description: String {
        return String(format: NSLocalizedString("Coins (%d)", comment: "Money description format"), amount)
    }
}
