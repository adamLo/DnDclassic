//
//  Opponent.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 22/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Opponent: Character {
    
    let order: Int
    
    required init?(json: JSON) {
        
        order = json[JSONkeys.order] as? Int ?? 0
        
        super.init(json: json)
    }
    
    private struct JSONkeys {
        static let order = "order"
    }
}
