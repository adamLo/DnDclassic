//
//  Glove.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 21/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Glove: Armor {
    
    override var type: InventoryItemType {
        return .glove
    }
    
    override var description: String {
        return name?.nilIfEmpty ?? identifier ?? Strings.itemDescriptionGloves
    }
}
