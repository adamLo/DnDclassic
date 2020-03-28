//
//  LogItem.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 28/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

enum LogEvent {
    case advance(sceneId: Int),
    kill(opponent: String),
    bonus(property: CharacterProperty, gain: Int),
    tryLuck(roll: Int, success: Bool),
    eat,
    rest(healthGain: Int?, dexterityGain: Int?),
    fight(opponent: String, playerAttack: Int, opponentAttack: Int),
    drink(type: CharacterProperty),
    escape(damage: Int),
    damage(value: Int),
    roll(value: Int),
    died
}

struct LogItem: CustomStringConvertible {
    
    let time = Date()
    let event: LogEvent
    let info: String?
    
    init(event: LogEvent, info: String? = nil) {
        
        self.event = event
        self.info = info
    }
    
    var description: String {
        
        var text: String!
        
        switch event {
        case .advance(let sceneId):
            text = String(format: NSLocalizedString("Advanced to scene %d", comment: "Advance event description format"), sceneId)
        case .bonus(let property, let gain):
            text = String(format: NSLocalizedString("Gained %d %@ bonus", comment: "Bonus event description format"), gain, property.description)
        case .damage(let value):
            text = String(format: NSLocalizedString("Damaga taken: %d", comment: "Damage event description format"), value)
        case .drink(let type):
            text = String(format: NSLocalizedString("Drank potion of %@", comment: "Drink event description format"), type.description)
        case .eat:
            text = String(format: NSLocalizedString("Eat", comment: "Eat event description"))
        case .escape(let damage):
            text = String(format: NSLocalizedString("Lost %d health while escaping fight", comment: "Escape event description format"), damage)
        case .fight(let opponent, let playerAttack, let opponentAttack):
            text = String(format: NSLocalizedString("Fight round with %@, attack: %d, opponent attack: %d", comment: "Fight event description format"), opponent, playerAttack, opponentAttack)
        case .kill(let opponent):
            text = String(format: NSLocalizedString("Killed %@", comment: "Kill event description format"), opponent)
        case .rest(let healthGain, let dexterityGain):
            text = String(format: NSLocalizedString("Rest gained %d health and %d dexterity", comment: "Rest event description format"), healthGain ?? 0, dexterityGain ?? 0)
        case .roll(let value):
            text = String(format: NSLocalizedString("Rolled %d", comment: "Roll event description format"), value)
        case .tryLuck(let roll, let success):
            text = String(format: NSLocalizedString("Tryed luck. Rolled %d = %@", comment: "Try luck event description format"), roll, success ? NSLocalizedString("Good luck", comment: "Good luck title") : NSLocalizedString("Bad luck", comment: "Bad luck title"))
        case .died:
            text = NSLocalizedString("Died", comment: "Die event description")
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = time.isToday ? .none : .short
        formatter.timeStyle = .medium
        
        text = formatter.string(from: time) + " " + text
        if let _info = info?.nilIfEmpty {
            text = text + " " + _info
        }
        
        return text
    }
}
