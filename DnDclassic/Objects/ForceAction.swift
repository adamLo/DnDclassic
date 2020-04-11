//
//  ForceAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 11/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class ForceAction: Action {
    
    let damage: Int
    let destination: Int
    
    required init?(json: JSON) {
        
        guard let _damage = json[JSONkeys.damage] as? Int else {return nil}
        damage = _damage
        
        guard let _destination = json[JSONkeys.destination] as? Int else {return nil}
        destination = _destination
        
        super.init(json: json)
    }
    
    private struct JSONkeys {
        static let damage       = "damage"
        static let destination  = "destination"
    }
}
