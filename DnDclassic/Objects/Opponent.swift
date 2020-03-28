//
//  Opponent.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 22/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Opponent: Character {
    
    let order: Int
    let killBonus: KillBonus?
    
    required init?(json: JSON) {
        
        order = json[JSONkeys.order] as? Int ?? 0
        
        if let _bonusObject = json[JSONkeys.killBonus] as? JSON, let _killBonus = KillBonus(json: _bonusObject) {
            killBonus = _killBonus
        }
        else {
            killBonus = nil
        }
        
        super.init(json: json)
    }
    
    private struct JSONkeys {
        static let order        = "order"
        static let killBonus    = "killBonus"
    }
}
