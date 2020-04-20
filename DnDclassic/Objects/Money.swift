//
//  Money.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Money: InventoryItem, Deserializable {

    let identifier: String? = "money"
    let type: InventoryItemType = .money
    let modifiedProperty: CharacterProperty? = nil
    let modifierValue: Int? = nil
    let name: String? = nil
    let canUnEquip: Bool? = true
    let attackBonus: Int? = nil
    let autoEquip: Bool? = false
    
    private(set) var amount: Int
    
    let consumeWhenUsed: Bool? = true
    
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
    
    func use(amount: Int) {
        
        self.amount = max(self.amount - amount, 0)
    }
    
    func add(amount: Int) {
        
        self.amount += amount
    }
}
