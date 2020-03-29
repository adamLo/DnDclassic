//
//  HitBonus.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class HitBonus: Bonus {
    
    let round: Int
    
    required init?(json: JSON) {
        
        guard let _round = json[JSONkeys.round] as? Int else {return nil}
        round = _round
        
        super.init(json: json)
    }
    
    private struct JSONkeys {
        static let round = "round"
    }
}
