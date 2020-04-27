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
        
        super.init(type: .money, name: String(format: Localization.itemDescriptionFormatMoney, amount))
        self.amount = amount
    }
    
    required init?(json: JSON) {
        
        super.init(json: json)
    }
    
    override var description: String {
        return String(format: Localization.itemDescriptionFormatMoney, amount)
    }
}
