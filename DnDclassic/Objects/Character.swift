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
    
    var coins: Int = 0
    private(set)var food: Int = 0
    
    private(set) var inventory = [InventoryItem]()
    private(set) var potions = [Potion]()
    
    var journey = [Scene]()
    
    init(isPlayer: Bool, name: String, dexerity: Int, health: Int, luck: Int, coins: Int, food: Int, potion: CharacterProperty? = nil, inventory: [InventoryItem]? = nil) {
        
        self.isPlayer = isPlayer
        self.name = name
        
        dexterityStarting = dexerity
        dexterityCurrent = dexerity
        
        healthStarting = health
        healthCurrent = health
        
        luckStarting = luck
        luckCurrent = luck
        
        self.coins = coins
        self.food = food
        
        if let _potionType = potion {
            self.potions = [Potion(type: _potionType)]
        }
        
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
        
        guard food > 0 else {return}
        
        food -= 1
        
        healthCurrent = min(healthCurrent + 4, healthStarting)
    }
    
    func drinkPotion(of type: CharacterProperty) {
        
        guard let index = potions.firstIndex(where: { (potion) -> Bool in
            return potion.type == type
        }) else {return}
        
        let potion = potions[index]
        
        if potion.amount <= 0 {
            potions.remove(at: index)
            return
        }
        
        potion.use()
        
        switch potion.type {
        case .dexerity:
            dexterityCurrent = dexterityStarting
        case .health:
            healthCurrent = healthStarting
        case .luck:
            luckCurrent = luckStarting
            luckStarting += 1
        }
        
        if potion.amount == 0 {
            potions.remove(at: index)
        }
    }
    
    func hitDamage(points: Int) {
        
        healthCurrent = max(healthCurrent - points, 0)
    }
    
    static var startInventory: [InventoryItem] {
     
        let sword = InventoryItem(type: .weapon, name: "Sword", identifier: 0)
        let armor = InventoryItem(type: .armor, name: "Leather Armor", identifier: 1)
        let lamp = InventoryItem(type: .lamp, name: "Lamp", identifier: 2)
        return [sword, armor, lamp]
    }
    
    static let startFoodAmount: Int = 10
    
    static let startCoinsAmount: Int = 0
}
