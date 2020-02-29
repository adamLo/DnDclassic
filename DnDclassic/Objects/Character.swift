//
//  Character.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Character {
    
    let name: String
    let isPlayer: Bool
    
    let dexterityStarting: Int
    var dexterityCurrent: Int = 0
    
    let healthStarting: Int
    private(set)var healthCurrent: Int  = 0
    
    private(set) var luckStarting: Int
    var luckCurrent: Int = 0
        
    private(set) var inventory = [InventoryItem]()
    
    var journey = [Scene]()
    
    init(isPlayer: Bool, name: String, dexerity: Int, health: Int, luck: Int, inventory: [InventoryItem]? = nil) {
        
        self.isPlayer = isPlayer
        self.name = name
        
        dexterityStarting = dexerity
        dexterityCurrent = dexerity
        
        healthStarting = health
        healthCurrent = health
        
        luckStarting = luck
        luckCurrent = luck
                
        if let _inventory = inventory {
            self.inventory = _inventory
        }
    }
    
    class func generate(property: CharacterProperty) -> Int {
        
        switch property {
        case .dexerity:
            return Dice(number: 1).roll(delta: 6)
        case .health:
            return Dice(number: 2).roll(delta: 12)
        case .luck:
            return Dice(number: 1).roll(delta: 6)
        }
    }
    
    func tryLuck(rolled: Int? = nil) -> (rolled: Int, success: Bool)  {
        
        let _rolled = rolled ?? Dice(number: 2).roll()
                    
        let result = _rolled <= luckCurrent
        
        luckCurrent = max(luckCurrent - 1, 0)
        
        return (_rolled, result)
    }
    
    func eat() {
        
        guard let food = inventory.first(where: { (item) -> Bool in
            return item.type == .food
        }) as? Food else {return}
        
        guard food.amount > 0 else {return}
        
        healthCurrent = min(healthCurrent + 4, healthStarting)
        food.eat()
    }
    
    func drinkPotion(of type: CharacterProperty) {
        
        guard let potion = inventory.first(where: { (item) -> Bool in
            return item.type == .potion
        }) as? Potion else {return}
                
        guard let potionType = potion.modifiesPropertyWhenUsed else {return}
        
        potion.use()
        
        switch potionType {
        case .dexerity:
            dexterityCurrent = dexterityStarting
        case .health:
            healthCurrent = healthStarting
        case .luck:
            luckCurrent = luckStarting
            luckStarting += 1
        }
        
        inventory.removeAll { (item) -> Bool in
            
            if potion.amount <= 0, let potionId = potion.identifier as? String, let itemId = item.identifier as? String, potionId == itemId {
                return true
            }
            return false
        }
    }
    
    func hitDamage(points: Int) {
        
        healthCurrent = max(healthCurrent - points, 0)
    }
    
    static var startInventory: [InventoryItem] {
     
        let sword = InventoryObject(type: .weapon, name: NSLocalizedString("Long sword", comment: "Long sword name"), identifier: "longsword_default")
        let armor = InventoryObject(type: .armor, name: NSLocalizedString("Leather Armor", comment: "Leather armor name"), identifier: "leatherarmor_default")
        let lamp = InventoryObject(type: .lighting, name: NSLocalizedString("Lamp", comment: "lamp name"), identifier: "lamp_default")
        let money = Money(amount: 0)
        let food = Food(amount: 10)
        
        return [sword, armor, lamp, money, food]
    }
}
