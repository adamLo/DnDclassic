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
    eat(healthGained: Int),
    rest(healthGain: Int?, dexterityGain: Int?),
    fight(opponent: String, playerAttack: Int, opponentAttack: Int),
    drink(type: CharacterProperty),
    escape(damage: Int),
    damage(value: Int),
    roll(value: Int),
    died,
    use(item: InventoryItem, amount: Int),
    damageModified(original: Int, new: Int, modifierName: String?),
    addInventory(item: InventoryItem),
    dropInventory(item: InventoryItem, amount: Int?),
    attackModified(value: Int),
    answered(question: String, answer: String, correct: Bool),
    extraAttack(damage: Int, caption: String?),
    extraAttackAvoided,
    extraAttackNoDamage(caption: String?)
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
            text = String(format: NSLocalizedString("Damage taken: %d", comment: "Damage event description format"), value)
        case .drink(let type):
            text = String(format: NSLocalizedString("Drank potion of %@", comment: "Drink event description format"), type.description)
        case .eat(let gained):
            text = String(format: NSLocalizedString("Ate a portion of food, gained %d health", comment: "Eat event description"), gained)
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
        case .use(let item, let amount):
            text = String(format: NSLocalizedString("Used %d amount of %@", comment: "Use invetory item event description format"), amount, item.description)
        case .damageModified(let original, let new, let modifierName):
            text = String(format: NSLocalizedString("Damage modified from %d to %d due %@", comment: "Damage modification event description format"), original, new, modifierName ?? "N/A")
        case .addInventory(let item):
            text = String(format: NSLocalizedString("Added %@ to inventory", comment: "Add inventory item event description format"), item.description)
        case .dropInventory(let item, let amount):
            text = (amount ?? 0) != 0 ? String(format: NSLocalizedString("Dropped %d of %@", comment: "Drop inventory item event description format with amount"), amount ?? 0,  item.description) : String(format: NSLocalizedString("Dropped %@", comment: "Drop inventory item event description format"), item.description)
        case .attackModified(let value):
            text = String(format: NSLocalizedString("Attack modified by %d", comment: "Attack modified event description format"), value)
        case .answered(let question, let answer, let correct):
            text = String(format: "%@ answered %@ for %@", correct ? NSLocalizedString("Correctly", comment: "Correct answer") : NSLocalizedString("Wrongly", comment: "Wrong answer"), answer, question)
        case .extraAttack(let damage, let caption):
            text = caption != nil ? String(format: NSLocalizedString("Extra attack damage taken: %d", comment: "Extra attack damage without caption format"), damage) : String(format: NSLocalizedString("Extra attack damage taken: %d due %@", comment: "Extra attack damage with caption format"), damage, caption ?? "")
        case .extraAttackAvoided:
            text = NSLocalizedString("Extra attack avoided with luck", comment: "Extra attack avoided event description")
        case .extraAttackNoDamage(let caption):
            text = caption != nil ? String(format: NSLocalizedString("Extra attack from opponent: %@", comment: caption ?? "")) : NSLocalizedString("Extra attack avoided with luck", comment: "Extra attack avoided event description")
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
