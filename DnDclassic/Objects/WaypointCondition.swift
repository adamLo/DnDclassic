//
//  WaypointCondition.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 11/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct WaypointCondition: Deserializable {
    
    let inventoryItemType: InventoryItemType
    let inventoryItemAmount: Int
    
    init?(json: JSON) {
        
        guard let __itemTypeString = json[JSONkeys.inventoryItemtype] as? String, let _itemTypeString = __itemTypeString.nilIfEmpty, let _itemType = InventoryItemType(rawValue: _itemTypeString) else {return nil}
        inventoryItemType = _itemType
        
        inventoryItemAmount = json[JSONkeys.amount] as? Int ?? 1
    }
    
    private struct JSONkeys {
        static let inventoryItemtype    = "inventoryItemtype"
        static let amount               = "amount"
    }
}
