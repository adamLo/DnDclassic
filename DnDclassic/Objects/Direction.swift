//
//  Direction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

enum Direction: String, CustomStringConvertible {
    
    case north, south, west, east, unknown, back
    
    var description: String {
        switch self {
        case .north:    return Localization.directionNorth
        case .south:    return Localization.directionSouth
        case .west:     return Localization.directionWest
        case .east:     return Localization.directionEast
        case .unknown:  return Localization.unknown
        case .back:     return Localization.directionBack
        }
    }
}
