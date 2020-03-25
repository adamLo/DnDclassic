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
    let action: Action
    
    init?(json: JSON) {
        
        guard let _roll = json[JSONKeys.roll] as? Int else {return nil}
        roll = _roll
        
        guard let _actionJson = json[JSONKeys.action] as? JSON, let _action = ActionFactory.action(json: _actionJson) else {return nil}
        action = _action        
    }
    
    private struct JSONKeys {
        static let roll = "roll"
        static let action = "action"
    }
}
