//
//  WaypointCondition.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 11/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct Condition: Deserializable {
    
    let inventoryItemType: InventoryItemType?
    let inventoryItemId: String?
    let inventoryItemAmount: Int
    
    init?(json: JSON) {
        
        if let __itemTypeString = json[JSONkeys.inventoryItemtype] as? String, let _itemTypeString = __itemTypeString.nilIfEmpty, let _itemType = InventoryItemType(rawValue: _itemTypeString) {
            inventoryItemType = _itemType
        }
        else {
            inventoryItemType = nil
        }
        
        inventoryItemId = json[JSONkeys.inventoryItemId] as? String
        
        inventoryItemAmount = json[JSONkeys.amount] as? Int ?? 1
        
        guard !(inventoryItemId == nil && inventoryItemType == nil) else {return nil}
    }
    
    private struct JSONkeys {
        static let inventoryItemtype    = "inventoryItemType"
        static let inventoryItemId      = "inventoryItemId"
        static let amount               = "amount"
    }
}
