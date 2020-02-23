//
//  Player.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Player {
    
    let name: String
    let isPlayer: Bool
    let gender: Gender
    
    let dexterityStarting: Int
    var dexterityCurrenty: Int = 0
    
    let healthStarting: Int
    private(set)var healthCurrent: Int  = 0
    
    private(set) var luckStarting: Int
    var luckCurrent: Int = 0
    
    var coins: Int = 0
    var gems: Int = 0
    private(set)var food: Int = 10
    
    private(set) var inventory = [Any]()
    private(set) var potions = [Potion]()
    
    init(isPlayer: Bool, name: String, gender: Gender, dexerity: Int, health: Int, luck: Int) {
        
        self.isPlayer = isPlayer
        self.name = name
        self.gender = gender
        
        dexterityStarting = dexerity
        dexterityCurrenty = dexerity
        
        healthStarting = health
        healthCurrent = health
        
        luckStarting = luck
        luckCurrent = luck
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
    
    @discardableResult
    func tryLuck(rolled: Int? = nil) -> (rolled: Int, success: Bool)  {
        
        let _rolled = rolled ?? Dice(number: 2).roll()
                    
        let result = _rolled <= luckCurrent
        
        luckCurrent = max(luckCurrent - 1, 0)
        
        return (_rolled, result)
    }
    
    func eat() {
        
        guard food > 0 else {return}
        
        food -= 1
        
        healthCurrent = min(healthCurrent + 1, healthStarting)
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
            dexterityCurrenty = dexterityStarting
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
}
