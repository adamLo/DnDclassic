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
    let inventoryItemAmount: Int?
    let onlyWhenNoFights: Bool?
    let onlyWhenVisited: Int?
    let onlyWhenNotVisited: Int?
        
    init?(json: JSON) {
        
        if let __itemTypeString = json[JSONkeys.inventoryItemtype] as? String, let _itemTypeString = __itemTypeString.nilIfEmpty, let _itemType = InventoryItemType(rawValue: _itemTypeString) {
            inventoryItemType = _itemType
        }
        else {
            inventoryItemType = nil
        }
        
        inventoryItemId = json[JSONkeys.inventoryItemId] as? String
        inventoryItemAmount = json[JSONkeys.inventoryItemAmount] as? Int

        onlyWhenNoFights = json[JSONkeys.onlyWhenNoFights] as? Bool
        onlyWhenVisited = json[JSONkeys.onlyWhenVisited] as? Int
        onlyWhenNotVisited = json[JSONkeys.onlyWhenNotVisited] as? Int
        
        guard !(inventoryItemId == nil && inventoryItemType == nil && onlyWhenNotVisited == nil && inventoryItemAmount == nil && onlyWhenNoFights == nil && onlyWhenVisited == nil) else {return nil}
    }
    
    private struct JSONkeys {
        static let inventoryItemtype    = "inventoryItemType"
        static let inventoryItemId      = "inventoryItemId"
        static let inventoryItemAmount  = "inventoryItemAmount"
        static let onlyWhenNoFights     = "onlyWhenNoFights"
        static let onlyWhenVisited      = "onlyWhenVisited"
        static let onlyWhenNotVisited   = "onlyWhenNotVisited"
    }
}
