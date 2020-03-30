//
//  Character.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Character: Deserializable, Equatable {
    
    let name: String
    let isPlayer: Bool
    
    let dexterityStarting: Int
    private(set) var dexterityCurrent: Int = 0
    
    let healthStarting: Int
    private(set)var healthCurrent: Int  = 0
    
    private(set) var luckStarting: Int
    private(set) var luckCurrent: Int = 0
        
    private(set) var inventory = [InventoryItem]()
    
    let id = UUID().uuidString
    
    struct JourneyMilestone {
        
        let sceneId: Int
        let sourceDirection: Direction
        let sourceSceneId: Int
    }
    
    private(set) var journey = [JourneyMilestone]()
    
    private(set) var log = [LogItem]()
    
    var changed: (() -> ())?
    
    init(isPlayer: Bool, name: String, dexterity: Int, health: Int, luck: Int, inventory: [InventoryItem]? = nil) {
        
        self.isPlayer = isPlayer
        self.name = name
        
        dexterityStarting = dexterity
        dexterityCurrent = dexterity
        
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
        case .dexterity:
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
        
        changed?()
        
        log(event: .tryLuck(roll: _rolled, success: result))
        
        return (_rolled, result)
    }
    
    func eat() {
        
        guard let food = inventory.first(where: { (item) -> Bool in
            return item.type == .food
        }) as? Food else {return}
        
        guard food.amount > 0 else {return}
        
        healthCurrent = min(healthCurrent + 4, healthStarting)
        food.eat()
        
        inventory.removeAll { (item) -> Bool in
            return item.type == .food && item.amount < 1
        }
        
        changed?()
        
        log(event: .eat)
    }
    
    func drink(potion: Potion) {
                        
        guard let potionType = potion.modifiesPropertyWhenUsed, potion.amount > 0 else {return}
        
        potion.use(amount: 1)
        
        switch potionType {
        case .dexterity:
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
        
        changed?()
        
        log(event: .drink(type: potionType))
    }
    
    func hitDamage(points: Int) {
        
        healthCurrent = max(healthCurrent - points, 0)
                
        changed?()
        
        log(event: .damage(value: points))
    }
    
    static var startInventory: [InventoryItem] {
     
        let sword = InventoryObject(type: .weapon, name: NSLocalizedString("Long sword", comment: "Long sword name"), identifier: "longsword_default")
        let armor = InventoryObject(type: .armor, name: NSLocalizedString("Leather Armor", comment: "Leather armor name"), identifier: "leatherarmor_default")
        let lamp = InventoryObject(type: .lighting, name: NSLocalizedString("Lamp", comment: "lamp name"), identifier: "lamp_default")
        let money = Money(amount: 0)
        let food = Food(amount: 10)
        
        return [sword, armor, lamp, money, food]
    }
    
    func advance(to scene: Scene) {
        
        var sourceId = 0
        var sourceDirection: Direction = .unknown
        if let lastMileStone = journey.last {
            sourceId = lastMileStone.sourceSceneId
            sourceDirection = lastMileStone.sourceDirection
        }
        
        let mileStone = JourneyMilestone(sceneId: scene.id, sourceDirection: sourceDirection, sourceSceneId: sourceId)
        journey.append(mileStone)
        
        log(event: .advance(sceneId: scene.id))
        
        if let bonus = scene.visitBonus {
            apply(bonus: bonus)
        }
    }
    
    var isDead: Bool {
        return healthCurrent <= 0
    }
    
    func escape(goodLuck: Bool? = nil) {
        
        var damage = 2
        if let _luck = goodLuck {
            damage = _luck ? 1 : 3
        }
        
        hitDamage(points: damage)
        
        log(event: .escape(damage: damage))
    }
    
    func rest(health: Int? = nil, dexterity: Int? = nil) {
        
        healthCurrent = min(healthCurrent + (health ?? 0), healthStarting)
        dexterityCurrent = min(dexterityCurrent + (dexterity ?? 0), dexterityStarting)
        changed?()
        
        log(event: .rest(healthGain: health, dexterityGain: dexterity))
    }
    
    func apply(bonus: Bonus) {
        
        switch bonus.property {
        case .dexterity: dexterityCurrent = min(dexterityCurrent + bonus.gain, dexterityStarting)
        case .health: healthCurrent = min(healthCurrent + bonus.gain, healthStarting)
        case .luck: luckCurrent = min(luckCurrent + bonus.gain, luckStarting)
        }
        
        log(event: .bonus(property: bonus.property, gain: bonus.gain))
    }
    
    func log(event: LogEvent) {
        
        let item = LogItem(event: event)
        log.append(item)
        
        print("\(item.description) \(name) \(isPlayer ? "- (\(NSLocalizedString("Player", comment: "Player title")))" : "")")
    }
    
    func hasInventoryItem(of type: InventoryItemType) -> Bool {
        
        let item = inventory.first { (_item) -> Bool in
            return _item.type == type
        }
        return item != nil
    }
    
    func add(inventoryItem: InventoryItem) {
        
        if inventoryItem.type == .food || inventoryItem.type == .money {
            for item in inventory {
                if item.type == inventoryItem.type {
                    item.add(amount: inventoryItem.amount)
                    changed?()
                    return
                }
            }
        }
        
        inventory.append(inventoryItem)
        changed?()
    }
    
    // MARK: - JSON
    
    required init?(json: JSON) {
        
        guard let _nameString = json[JSONKeys.name] as? String, let _name = _nameString.nilIfEmpty else {return nil}
        name = _name
        
        guard let _dexterity = json[JSONKeys.dexterity] as? Int else {return nil}
        dexterityStarting = _dexterity
        dexterityCurrent = _dexterity
        
        guard let _health = json[JSONKeys.health] as? Int else {return nil}
        healthStarting = _health
        healthCurrent = _health
        
        isPlayer = false
        luckStarting = 0
        luckCurrent = 0
    }
    
    private struct JSONKeys {
        static let name         = "name"
        static let dexterity    = "dexterity"
        static let health       = "health"
    }
    
    // MARK: - Equatable
    
    static func == (lhs: Character, rhs: Character) -> Bool {
        return lhs.id == rhs.id
    }
        
}
