//
//  Money.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Money: InventoryItem, Deserializable {

    let identifier: Any? = "money"
    let type: InventoryItemType = .money
    let modifiesPropertyWhenEquipped: CharacterProperty? = nil
    let modifierValueWhenEquipped: Int? = nil
    let modifiesPropertyWhenUsed: CharacterProperty? = nil
    let modiferValueWhenUsed: Int? = nil
    
    var amount: Int
    
    init(amount: Int) {
        self.amount = amount
    }
    
    var description: String {
        return String(format: NSLocalizedString("Coins (%d)", comment: "Money description format"), amount)
    }
    
    // MARK: - JSON
    
    required convenience init?(json: JSON) {
        
        guard let _amount = json[InventoryObject.JSONKeys.amount] as? Int else {return nil}
        
        self.init(amount: _amount)
    }
}
