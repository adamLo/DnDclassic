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
    /// If true, roll is a win of money
    let rollGainsMoney: Bool
    
    required init?(json: JSON) {

        guard let _goodLuckJson = json[JSONkeys.goodLuck] as? JSON, let _goodLuck = WayPoint(json: _goodLuckJson) else {return nil}
        guard let _badLuckJson = json[JSONkeys.badLuck] as? JSON, let _badLuck = WayPoint(json: _badLuckJson) else {return nil}
        
        goodLuck = _goodLuck
        badLuck = _badLuck
        rollGainsMoney = _goodLuckJson[JSONkeys.rollGainsMoney] as? Bool ?? false
        
        super.init(json: json)
    }
    
    private struct JSONkeys {
        static let goodLuck         = "goodLuck"
        static let badLuck          = "badLuck"
        static let rollGainsMoney   = "rollGainsMoney"
    }
}
