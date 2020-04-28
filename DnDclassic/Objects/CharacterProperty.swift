//
//  CharacterProperty.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

enum CharacterProperty: String, CustomStringConvertible {
    
    case dexterity, health, luck
    
    var description: String {
        switch self {
        case .dexterity:    return Strings.dexterity
        case .health:       return Strings.health
        case .luck:         return Strings.luck
        }
    }
}
