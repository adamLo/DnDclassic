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
        case .north:    return Strings.directionNorth
        case .south:    return Strings.directionSouth
        case .west:     return Strings.directionWest
        case .east:     return Strings.directionEast
        case .unknown:  return Strings.unknown
        case .back:     return Strings.directionBack
        }
    }
}
