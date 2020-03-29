//
//  EscapeAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class EscapeAction: Action {
    
    let direction: Direction
    let destination: Int
    
    required init?(json: JSON) {
        
        guard let _directionString = json[JSONKeys.direction] as? String, let _direction = Direction(rawValue: _directionString) else {return nil}
        guard let _destination = json[JSONKeys.destination] as? Int else {return nil}
        
        direction = _direction
        destination = _destination
        
        super.init(json: json)
    }
        
    private struct JSONKeys {
        static let direction    = "direction"
        static let destination  = "destination"
    }
}
