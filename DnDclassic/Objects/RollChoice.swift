//
//  RollChoice.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 25/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

struct RollChoice: Deserializable {
    
    let roll: Int
    let action: Action?
    let waypoint: WayPoint?
    
    init?(json: JSON) {
        
        guard let _roll = json[JSONkeys.roll] as? Int else {return nil}
        roll = _roll
        
        if let _actionJson = json[JSONkeys.action] as? JSON {
            guard let _action = ActionFactory.action(json: _actionJson) else {return nil}
            action = _action
        }
        else {
            action = nil
        }
        
        if let _waypointJson = json[JSONkeys.waypoint] as? JSON {
            guard let _waypoint = WayPoint(json: _waypointJson) else {return nil}
            waypoint = _waypoint
        }
        else {
            waypoint = nil
        }
        
        guard !(waypoint == nil && action == nil) else {return nil}
    }
    
    private struct JSONkeys {
        static let roll     = "roll"
        static let action   = "action"
        static let waypoint = "waypoint"
    }
}
