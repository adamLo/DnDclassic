//
//  Scene.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation
import UIKit

class Scene: Deserializable {
    
    let id: Int
    let story: String
    let image: UIImage?
    
    let wayPoints: [WayPoint]?
    private(set) var inventory: [InventoryItem]?
    let actions: [Action]?
    let returnWaypoints: [WayPoint]?
    let visitBonus: Bonus?
        
    required init?(json: JSON) {
        
        guard let _id = json[JSONKeys.id] as? Int else {return nil}
        id = _id
        
        guard let _story = json[JSONKeys.story] as? String else {return nil}
        story = _story
        
        // Image
        if let _imageName = json[JSONKeys.cover] as? String, let _image = UIImage(named: _imageName) {
            image = _image
        }
        else {
            image = nil
        }
        
        if _id == 135 {
            print("Gotcha!")
        }
        
        // inventory
        var _inventory = [InventoryItem]()
        if let _inventoryObjects = json[JSONKeys.inventory] as? JSONArray {
            for _json in _inventoryObjects {
                guard let _item = InventoryItemFactory.item(json: _json) else {return nil}
                _inventory.append(_item)
            }
        }
        if !_inventory.isEmpty {
            inventory = _inventory
        }
        else {
            inventory = nil
        }
        
        // Waypoints
        var _waypoints = [WayPoint]()
        if let _waypointsArray = json[JSONKeys.waypoints] as? JSONArray {
            for _waypointJson in _waypointsArray {
                guard let _wayPoint = WayPoint(json: _waypointJson) else {return nil}
                _waypoints.append(_wayPoint)
            }
        }
        if !_waypoints.isEmpty {
            wayPoints = _waypoints
        }
        else {
            wayPoints = nil
        }
        
        // Actions
        var _actions = [Action]()
        if let _actionsArray = json[JSONKeys.actions] as? JSONArray {
            for _actionJson in _actionsArray {
                guard let _action = ActionFactory.action(json: _actionJson) else {return nil}
                _actions.append(_action)
            }
        }
        if !_actions.isEmpty {
            actions = _actions
        }
        else {
            actions = nil
        }
        
        var _returns = [WayPoint]()
        if let _returnsArray = json[JSONKeys.returnWps] as? JSONArray {
            for _waypointJson in _returnsArray {
                guard let _waypoint = WayPoint(json: _waypointJson) else {return nil}
                _returns.append(_waypoint)
            }
        }
        returnWaypoints = _returns.isEmpty ? nil :_returns
        
        if let bonusObject = json[JSONKeys.visitBonus] as? JSON, let _bonus = Bonus(json: bonusObject) {
            visitBonus = _bonus
        }
        else {
            visitBonus = nil
        }
    }
    
    func grabbed(inventory index: Int) {
        
        inventory?.remove(at: index)
        inventory?.removeAll(where: { (item) -> Bool in
            item.amount <= 0
        })
    }
    
    private struct JSONKeys {
        static let id           = "id"
        static let story        = "story"
        static let waypoints    = "waypoints"
        static let actions      = "actions"
        static let cover        = "cover"
        static let returnWps    = "return"
        static let visitBonus   = "visitBonus"
        static let inventory    = "inventory"
    }
}
