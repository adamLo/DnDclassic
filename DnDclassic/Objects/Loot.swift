//
//  Loot.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct Loot: Deserializable {
    
    init?(json: JSON) {
    
    }
    
    private struct JSONkeys {
        static let type = "type"
        static let amount = "amount"
    }
}
