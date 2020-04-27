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
            text = String(format: Localization.eventDescriptionAdvance, sceneId)
        case .bonus(let property, let gain):
            text = String(format: Localization.eventDescriptionGain, gain, property.description)
        case .damage(let value):
            text = String(format: Localization.eventDescriptionDamageTaken, value)
        case .drink(let type):
            text = String(format: Localization.eventDescriptionDrinkPotion, type.description)
        case .eat(let gained):
            text = String(format: Localization.eventDescriptionEat, gained)
        case .escape(let damage):
            text = String(format: Localization.eventDescriptionEscape, damage)
        case .fight(let opponent, let playerAttack, let opponentAttack):
            text = String(format: Localization.eventDescriptionFigtRound, opponent, playerAttack, opponentAttack)
        case .kill(let opponent):
            text = String(format: Localization.eventDescriptionKill, opponent)
        case .rest(let healthGain, let dexterityGain):
            text = String(format: Localization.eventDescriptionRest, healthGain ?? 0, dexterityGain ?? 0)
        case .roll(let value):
            text = String(format: Localization.eventDescriptionRoll, value)
        case .tryLuck(let roll, let success):
            text = String(format: Localization.eventDescriptionTryLuck, roll, success ? Localization.goodLuck : Localization.badLuck)
        case .died:
            text = Localization.eventDescriptionDied
        case .use(let item, let amount):
            text = String(format: Localization.eventDescriptionUseItem, amount, item.description)
        case .damageModified(let original, let new, let modifierName):
            text = String(format: Localization.eventDescriptionDamageMod, original, new, modifierName ?? "N/A")
        case .addInventory(let item):
            text = String(format: Localization.eventDescriptionAddInventory, item.description)
        case .dropInventory(let item, let amount):
            text = (amount ?? 0) != 0 ? String(format: Localization.eventDescriptionDroppedAmount, amount ?? 0,  item.description) : String(format: Localization.eventDescriptionDropItem, item.description)
        case .attackModified(let value):
            text = String(format: Localization.eventDescriptionAttackMod, value)
        case .answered(let question, let answer, let correct):
            text = String(format: Localization.eventDescriptionQueryAnswer, correct ? Localization.correctly : Localization.wrongly, answer, question)
        case .extraAttack(let damage, let caption):
            text = caption != nil ? String(format: Localization.eventDescriptionExtraDamageTaken, damage) : String(format: Localization.eventDescriptionExtraDamageCause, damage, caption ?? "")
        case .extraAttackAvoided:
            text = Localization.eventDescriptionExtraAttackAvoid
        case .extraAttackNoDamage(let caption):
            text = caption != nil ? String(format: Localization.eventDescriptionExtraAttackOpp, caption ?? "") : Localization.eventDescriptionExtraAttackAvoid
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
