//
//  TradeAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class TradeAction: Action {
    
    private(set) var items: [TradeItem]
    
    required init?(json: JSON) {
        
        guard let _itemsJson = json[JSONkeys.items] as? JSONArray, _itemsJson.count > 0 else {return nil}
        var _items = [TradeItem]()
        for _itemJson in _itemsJson {
            guard let _item = TradeItem(json: _itemJson) else {return nil}
            _items.append(_item)
        }
        guard !_items.isEmpty else {return nil}
        items = _items
        
        super.init(json: json)
    }
    
    private struct JSONkeys {
        static let items = "items"
    }
}
