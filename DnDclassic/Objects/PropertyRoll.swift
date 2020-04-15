//
//  PropertyRoll.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 15/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct PropertyRoll {
    
    let character: Character
    let action: PropertyRollAction
    
    init(character: Character, action: PropertyRollAction) {
        
        self.character = character
        self.action = action
    }
    
    func roll() -> (roll: Int, waypoint: WayPoint) {
        
        let roll = Dice(number: action.dice).roll()
        
        var equalOrLess = true
        for property in action.properties {
            let value = GameData.shared.player.value(of: property)
            if roll > value {
                equalOrLess = false
                break
            }
        }
        
        let waypoint = equalOrLess ? action.equalOrLess : action.greater
        return (roll, waypoint)
    }
}
