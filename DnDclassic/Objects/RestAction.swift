//
//  RestAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 22/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class RestAction: Action {
    
    let health: Int?
    let dexterity: Int?
    let finished: [WayPoint]
    
    required init?(json: JSON) {
        
        guard let _finishedObjects = json[JSONKeys.finished] as? JSONArray else {return nil}
        var _finished = [WayPoint]()
        for object in _finishedObjects {
            if let waypoint = WayPoint(json: object) {
                _finished.append(waypoint)
            }
        }
        guard !_finished.isEmpty else {return nil}
        finished = _finished
                
        health = json[JSONKeys.health] as? Int
        dexterity = json[JSONKeys.dexterity] as? Int
        
        super.init(json: json)
    }
    
    private struct JSONKeys {
        
        static let health       = "health"
        static let dexterity    = "dexterity"
        static let finished     = "finished"
    }
}
