//
//  Dice.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct Dice {
    
    private let multiplier: Int
    private let sides: Int
    
    init(number: Int = 1, sides: Int = 6) {
        
        self.multiplier = number
        self.sides = sides
    }
    
    func roll(delta: Int = 0) -> Int {
        
        var result = 0
        
        for _ in 0..<multiplier {
            result += Int.random(in: 1...sides)
        }
        
        result += delta
        
        return result
    }
}
