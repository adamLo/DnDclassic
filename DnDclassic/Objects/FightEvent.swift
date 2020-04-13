//
//  FightEvent.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 13/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct FightEvent: Deserializable {
    
    let round: Int
    let waypoint: WayPoint
    
    init?(json: JSON) {
        
        guard let _round = json[JSONkeys.round] as? Int, _round > 0 else {return nil}
        round = _round
        
        guard let _waypointObject = json[JSONkeys.waypoint] as? JSON, let _waypoint = WayPoint(json: _waypointObject) else {return nil}
        waypoint = _waypoint
    }
    
    private struct JSONkeys {
        static let round    = "round"
        static let waypoint = "waypoint"
    }
}
