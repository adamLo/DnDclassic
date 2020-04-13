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
    let condition: Condition?
    
    init?(json: JSON) {
        
        guard let _directionString = json[JSONKeys.direction] as? String, let _direction = Direction(rawValue: _directionString) else {return nil}
        guard let _destination = json[JSONKeys.destination] as? Int else {return nil}
        guard let _caption = json[JSONKeys.caption] as? String else {return nil}
        
        direction = _direction
        destination = _destination
        caption = _caption
        
        if let _conditionObject = json[JSONKeys.condition] as? JSON {
            guard let _condition = Condition(json: _conditionObject) else {return nil}
            condition = _condition
        }
        else {
            condition = nil
        }
    }
    
    init(direction: Direction, destination: Int, caption: String) {
        
        self.direction = direction
        self.destination = destination
        self.caption = caption
        condition = nil
    }
    
    private struct JSONKeys {
        static let direction    = "direction"
        static let destination  = "destination"
        static let caption      = "caption"
        static let condition    = "condition"
    }
}
