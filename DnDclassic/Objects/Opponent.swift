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
    let killBonus: Bonus?
    let damagedBy: InventoryItemType?
    let hitBonus: HitBonus?
    
    init(name: String, dexterity: Int, health: Int, luck: Int, order: Int, killBonus: Bonus? = nil) {
        
        self.order = order
        self.killBonus = killBonus
        self.damagedBy = nil
        self.hitBonus = nil
        
        super.init(isPlayer: false, name: name, dexterity: dexterity, health: health, luck: luck)
    }
    
    required init?(json: JSON) {
        
        order = json[JSONkeys.order] as? Int ?? 0
        
        if let _bonusObject = json[JSONkeys.killBonus] as? JSON, let _killBonus = Bonus(json: _bonusObject) {
            killBonus = _killBonus
        }
        else {
            killBonus = nil
        }
        
        if let _damageString = json[JSONkeys.damagedBy] as? String, let _type = InventoryItemType(rawValue: _damageString) {
            damagedBy = _type
        }
        else {
            damagedBy = nil
        }
        
        if let _bonusObject = json[JSONkeys.hitBonus] as? JSON, let _bonus = HitBonus(json: _bonusObject) {
            hitBonus = _bonus
        }
        else {
            hitBonus = nil
        }
        
        super.init(json: json)
    }
    
    private struct JSONkeys {
        static let order        = "order"
        static let killBonus    = "killBonus"
        static let damagedBy    = "damagedBy"
        static let hitBonus     = "hitBonus"
    }
}
