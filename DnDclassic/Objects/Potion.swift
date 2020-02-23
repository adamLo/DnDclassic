//
//  Potion.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Potion {
    
    let type: CharacterProperty
    
    let name: String
    
    private(set) var amount: Int = 2
    
    init(type: CharacterProperty) {
        
        self.type = type
        name = "Potion of \(type.rawValue)"
    }
    
    func use() {
        amount = max(amount - 1, 0)
    }
}
