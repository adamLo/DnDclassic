//
//  WayPoint.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct WayPoint: Deserializable {
    
    let direction: Direction
    let destination: Int
    let caption: String
    
    init?(json: JSON) {
        
        guard let _directionString = json[JSONKeys.direction] as? String, let _direction = Direction(rawValue: _directionString) else {return nil}
        guard let _destination = json[JSONKeys.destination] as? Int else {return nil}
        guard let _caption = json[JSONKeys.caption] as? String else {return nil}
        
        direction = _direction
        destination = _destination
        caption = _caption
    }
    
    private struct JSONKeys {
        static let direction    = "direction"
        static let destination  = "destination"
        static let caption      = "caption"
    }
}
