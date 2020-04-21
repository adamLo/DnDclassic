//
//  Armor.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 21/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Armor: InventoryObject {
    
    override var type: InventoryItemType {
        return .armor
    }
        
    required init?(json: JSON) {
        
        super.init(json: json)
    }
    
    override var description: String {
        return name?.nilIfEmpty ?? identifier ?? NSLocalizedString("Armor", comment: "Armor title")
    }
        
    override func use(amount: Int) {
    }
    
    override func add(amount: Int) {
    }
}
