//
//  TryLuckAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 08/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class TryLuckAction: Action {
    
    let goodLuck: WayPoint
    let badLuck: WayPoint
    
    required init?(json: JSON) {

        guard let _goodLuckJson = json[JSONKeys.goodLuck] as? JSON, let _goodLuck = WayPoint(json: _goodLuckJson) else {return nil}
        guard let _badLuckJson = json[JSONKeys.badLuck] as? JSON, let _badLuck = WayPoint(json: _badLuckJson) else {return nil}
        
        goodLuck = _goodLuck
        badLuck = _badLuck
        
        super.init(json: json)
    }
    
    private struct JSONKeys {
        static let goodLuck = "goodLuck"
        static let badLuck  = "badLuck"
    }
}
