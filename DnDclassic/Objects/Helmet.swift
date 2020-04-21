//
//  Helmet.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 20/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Helmet: Armor {
    
    override var type: InventoryItemType {
        return .helmet
    }

    override var description: String {
        return name?.nilIfEmpty ?? identifier ?? NSLocalizedString("Helmet", comment: "Helmet title")
    }
}
