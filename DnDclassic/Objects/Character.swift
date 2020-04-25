//
//  Character.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class InventoryWrapper: Equatable, CustomStringConvertible {
    
    let item: InventoryItem
    var equipped = false
    
    let identifier = UUID().uuidString
    
    init(item: InventoryItem, equipped: Bool = false) {
        self.item = item
        self.equipped = equipped
    }

    static func == (lhs: InventoryWrapper, rhs: InventoryWrapper) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var description: String {
        return item.description + (equipped ? " [Equipped]" : "") + " \(identifier)"
    }
}

class Character: Deserializable, Equatable {
    
    let name: String
    let isPlayer: Bool
    
    let dexterityStarting: Int
    private var dexterityCurrent: Int = 0
    var dexterity: Int {
        var result = dexterityCurrent
        for item in inventory {
            if item.equipped, let type = item.item.modifiedProperty, type == .dexterity, let value = item.item.modifierValue {
                result += value
            }
        }
        return result
    }
    
    let healthStarting: Int
    private var healthCurrent: Int  = 0
    var health: Int {
        var result = healthCurrent
        for item in inventory {
            if item.equipped, let type = item.item.modifiedProperty, type == .health, let value = item.item.modifierValue {
                result += value
            }
        }
        return result
    }
    
    private(set) var luckStarting: Int
    private var luckCurrent: Int = 0
    var luck: Int {
        var result = luckCurrent
        for item in inventory {
            if item.equipped, let type = item.item.modifiedProperty, type == .luck, let value = item.item.modifierValue {
                result += value
            }
        }
        return result
    }
            
    private(set) var inventory = [InventoryWrapper]()
    
    let id = UUID().uuidString
    
    struct JourneyMilestone {
        
        let sceneId: Int
        let sourceDirection: Direction
        let sourceSceneId: Int
    }
    
    private(set) var journey = [JourneyMilestone]()
    
    private(set) var log = [LogItem]()
    
    var changed: (() -> ())?
    
    init(isPlayer: Bool, name: String, dexterity: Int, health: Int, luck: Int, inventory: [InventoryWrapper]? = nil) {
        
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
    
    func eat(gainModifier: Int?) {
        
        guard let food = inventory.first(where: { (item) -> Bool in
            return item.item.type == .food
        })?.item as? Food else {return}
        
        guard food.amount > 0 else {return}
        
        let gain = max((gainModifier ?? 0) + 4, 0)
        healthCurrent = min(healthCurrent + gain, healthStarting)
        food.eat()
        
        inventory.removeAll { (item) -> Bool in
            return item.item.type == .food && item.item.amount < 1
        }
        
        changed?()
        
        log(event: .eat(healthGained: gain))
    }
    
    func drink(potion: Potion) {
                        
        guard let potionType = potion.modifiedProperty, potion.amount > 0 else {return}
        
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
            
            if potion.amount <= 0, let potionId = potion.identifier, let itemId = item.item.identifier, potionId == itemId {
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
    
    static var startInventory: [InventoryWrapper] {
     
        let sword = InventoryObject(type: .sword, name: NSLocalizedString("Long sword", comment: "Long sword name"), identifier: "longsword_default")
        let armor = InventoryObject(type: .armor, name: NSLocalizedString("Leather Armor", comment: "Leather armor name"), identifier: "leatherarmor_default")
        let lamp = InventoryObject(type: .lighting, name: NSLocalizedString("Lamp", comment: "lamp name"), identifier: "lamp_default")
        let food = Food(amount: 10)
        
        return [
            InventoryWrapper(item: sword, equipped: true),
            InventoryWrapper(item: armor, equipped: true),
            InventoryWrapper(item: lamp),
            InventoryWrapper(item: food)
        ]
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
        
        if let bonuses = scene.visitBonus {
            for bonus in bonuses {
                apply(bonus: bonus)
            }
        }
        
        if let toPay = scene.payOnVisit, toPay > 0 {
            scene.payed(amount: pay(amount: toPay))
        }
        
        if let _inventory = scene.inventory {
            
            var indexesToRemove = [Int]()
            
            for index in 0..<_inventory.count {
                let item = _inventory[index]
                if item.autoEquip ?? false {
                    if let wrapper = add(inventoryItem: item) {
                        equip(item: wrapper, equipped: true)
                    }
                    indexesToRemove.append(index)
                    changed?()
                }
                else if item.amount < 0 {
                    drop(item: item, amount: abs(item.amount))
                    indexesToRemove.append(index)
                }
            }
            
            for index in indexesToRemove {
                scene.grabbed(inventory: index)
            }
        }
    }
    
    var isDead: Bool {
        return healthCurrent <= 0
    }
    
    func escape(goodLuck: Bool? = nil, escapeDamage: Int? = 0) {
        
        var damage = 2
        if let _luck = goodLuck {
            damage = _luck ? 1 : 3
        }
        
        damage += (escapeDamage ?? 0)
        
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
        
        var gain = 0
        var newValue = 0
        
        switch bonus.property {
            
        case .dexterity:
            if let _gain = bonus.gain {
                newValue = min(dexterityCurrent + _gain, dexterityStarting)
            }
            else if let _delta = bonus.resetDelta {
                newValue = max(dexterityCurrent, dexterityStarting + _delta)
            }
            gain = dexterityCurrent - newValue
            dexterityCurrent = newValue
            
        case .health:
            if let _gain = bonus.gain {
                newValue = min(healthCurrent + _gain, healthStarting)
            }
            else if let _delta = bonus.resetDelta {
                newValue = max(healthCurrent, healthStarting + _delta)
            }
            gain = healthCurrent - newValue
            healthCurrent = newValue
            
        case .luck:
            if let _gain = bonus.gain {
                newValue = min(luckCurrent + _gain, luckStarting)
            }
            else if let _delta = bonus.resetDelta {
                newValue = max(luckCurrent, luckStarting + _delta)
            }
            gain = max(luckCurrent - newValue, 0)
            luckCurrent = newValue
        }
        
        if gain != 0 {
            changed?()
            log(event: .bonus(property: bonus.property, gain: gain))
        }
    }
    
    func log(event: LogEvent) {
        
        let item = LogItem(event: event)
        log.append(item)
        
        print("\(item.description) \(name) \(isPlayer ? "- (\(NSLocalizedString("Player", comment: "Player title")))" : "")")
    }
    
    func hasInventoryItem(of type: InventoryItemType) -> Bool {
        
        let item = inventory.first { (_item) -> Bool in
            return _item.item.type == type
        }
        return item != nil
    }
    
    func hasItem(identifier: String) -> Bool {
        
        return inventory.firstIndex(where: {$0.item.identifier == identifier}) != nil
    }
    
    private func clearInventory() {
        
        inventory.removeAll { (item) -> Bool in
            return item.item.amount <= 0
        }
    }
    
    @discardableResult
    func add(inventoryItem: InventoryItem) -> InventoryWrapper? {
        
        log(event: .addInventory(item: inventoryItem))
        
        if inventoryItem.type == .food || inventoryItem.type == .money {
            for item in inventory {
                if item.item.type == inventoryItem.type {
                    if let money = item.item as? Money {
                        money.add(amount: inventoryItem.amount)
                        changed?()
                        return nil
                    }
                    else if let food = item.item as? Food {
                        food.add(amount: inventoryItem.amount)
                        changed?()
                        return nil
                    }
                }
            }
        }
        
        let wrapper = InventoryWrapper(item: inventoryItem)
        inventory.append(wrapper)
        changed?()
        return wrapper
    }
    
    func drop(inventoryItem: InventoryWrapper) {
        
        inventory.removeAll { (item) -> Bool in
            return item == inventoryItem
        }
        
        changed?()
        log(event: .dropInventory(item: inventoryItem.item, amount: nil))
    }
    
    @discardableResult
    func drop(item: InventoryItem, amount: Int) -> Int {
        
        var droppedAmount = 0
        
        for _item in inventory {
            
            let toDrop = amount - droppedAmount
            if toDrop <= 0 {
                break
            }
            
            if let id1 = _item.item.identifier?.nilIfEmpty, let id2 = item.identifier?.nilIfEmpty, id1 == id2 {
                let _toDrop = min(_item.item.amount, toDrop)
                _item.item.drop(amount: _toDrop)
                droppedAmount += _toDrop
                log(event: .dropInventory(item: _item.item, amount: _toDrop))
            }
            else if item.identifier?.nilIfEmpty == nil, _item.item.identifier?.nilIfEmpty == nil, _item.item.type == item.type {
                let _toDrop = min(_item.item.amount, toDrop)
                _item.item.drop(amount: _toDrop)
                droppedAmount += _toDrop
                log(event: .dropInventory(item: _item.item, amount: _toDrop))
            }
        }
        
        clearInventory()
        changed?()
        
        return droppedAmount
    }
    
    func canEquip(item: InventoryItem) -> Bool {
        
        guard item.type.equippable else {return false}
        
        for _item in inventory {
            if _item.equipped, !_item.item.type.canEquipWithOther(type: item.type) {
                if !(_item.item.canUnEquip ?? true) {
                    return false
                }
            }
        }
        
        return true
    }

    @discardableResult
    func equip(item: InventoryWrapper, equipped: Bool) -> Bool {
        
        guard item.item.type.equippable else {return false}
        guard canEquip(item: item.item) else {return false}
        
        item.equipped = equipped
        
        if equipped {
            // Check for mutual exclusivity
            for _item in inventory {
                if item != _item, _item.item.type.equippable, !item.item.type.canEquipWithOther(type: _item.item.type) {
                    _item.equipped = false
                }
            }
        }
        
        changed?()
        
        return true
    }
    
    @discardableResult
    func pay(amount: Int) -> Int {
        
        var payed = 0
        for _item in inventory {
            if _item.item.type == .money, _item.item.amount > 0 {
                let _toPay = amount - payed
                if _toPay <= 0 {
                    break
                }
                let _payed = min(_toPay, _item.item.amount)
                _item.item.use(amount: _payed)
                payed += _payed
                if payed >= amount {
                    break
                }
            }
        }
        
        inventory.removeAll { (_item) -> Bool in
            return _item.item.amount <= 0
        }
        
        changed?()
        return payed
    }
        
    func isFulfilled(condition: Condition) -> Bool {
        
        if condition.inventoryItemId == nil && (condition.inventoryItemType == nil || (condition.inventoryItemAmount ?? 0) == 0) {
            return true
        }
        
        var count = 0
        
        for item in inventory {
            if let requiredType = condition.inventoryItemType, item.item.type == requiredType, item.item.amount > 0 {
                count += item.item.amount
            }
            else if let requiredId = condition.inventoryItemId, item.item.identifier == requiredId, item.item.amount > 0 {
                count += 1
            }
        }
        
        return count >= (condition.inventoryItemAmount ?? 0)
    }
    
    func use(itemIn condition: Condition) {
        
        if condition.inventoryItemId == nil && (condition.inventoryItemType == nil || (condition.inventoryItemAmount ?? 0) == 0) {
            return
        }
        
        var usedAmount = 0
        
        for item in inventory {
            
            let amount = item.item.amount < (condition.inventoryItemAmount ?? 0) - usedAmount ? item.item.amount : (condition.inventoryItemAmount ?? 0) - usedAmount
            
            if let requiredType = condition.inventoryItemType, item.item.type == requiredType, item.item.amount > 0 {
                item.item.use(amount: amount)
                usedAmount += amount
                log(event: .use(item: item.item, amount: amount))
            }
            else if let requiredId = condition.inventoryItemId, item.item.identifier == requiredId, item.item.amount > 0 {
                item.item.use(amount: amount)
                usedAmount += amount
                log(event: .use(item: item.item, amount: amount))
            }
            
            if usedAmount >= condition.inventoryItemAmount ?? 0 {
                break
            }
        }
        
        inventory.removeAll { (item) -> Bool in
            return item.item.amount <= 0
        }
        
        changed?()
    }
    
    func value(of property: CharacterProperty) -> Int {
        
        switch property {
        case .dexterity: return dexterity
        case .health: return health
        case .luck: return luck
        }
    }
    
    func die() {
        
        healthCurrent = 0
        luckCurrent = 0
        dexterityCurrent = 0
        
        for item in inventory {
            if item.equipped {
                equip(item: item, equipped: false)
            }
        }
    }
    
    func reset() {
        
        healthCurrent = healthStarting
        luckCurrent = luckStarting
        dexterityCurrent = dexterityStarting
        
        inventory.removeAll()
        inventory = Character.startInventory
        
        log.removeAll()
        journey.removeAll()        
    }
    
    var money: Int {
        
        var result = 0
        
        for item in inventory {
            if item.item.type == .money {
                result += item.item.amount
            }
        }
        
        return result
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
