//
//  TradeItem.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 24/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct TradeItem: Deserializable {
    
    let inventoryItem: InventoryItem
    let price: Int
    
    init?(json: JSON) {
        
        guard let _itemJson = json[JSONkeys.item] as? JSON, let _item = InventoryItemFactory.item(json: _itemJson) else {return nil}
        inventoryItem = _item
        
        guard let _price = json[JSONkeys.price] as? Int else {return nil}
        price = _price        
    }
    
    private struct JSONkeys {
        static let item     = "item"
        static let price    = "price"
    }
}
