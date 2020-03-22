//
//  Scene.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation
import UIKit

struct Scene: Deserializable {
    
    let id: Int
    let story: String
    let image: UIImage?
    
    let wayPoints: [WayPoint]?
    var items: [InventoryItem]?
    let actions: [Action]?
        
    init?(json: JSON) {
        
        // ID, Story
        guard let _id = json[JSONKeys.id] as? Int else {return nil}
        guard let _story = json[JSONKeys.story] as? String else {return nil}
        id = _id
        story = _story
        
        // Image
        if let _imageName = json[JSONKeys.cover] as? String, let _image = UIImage(named: _imageName) {
            image = _image
        }
        else {
            image = nil
        }
        
        // FIXME: Load items
        items = nil
        
        // Waypoints
        var _waypoints = [WayPoint]()
        if let _waypointsArray = json[JSONKeys.waypoints] as? JSONArray {
            for _waypointJson in _waypointsArray {
                if let _wayPoint = WayPoint(json: _waypointJson) {
                    _waypoints.append(_wayPoint)
                }
            }
        }
        if !_waypoints.isEmpty {
            wayPoints = _waypoints
        }
        else {
            wayPoints = nil
        }
        
        if _id == 11 {
            print("11")
        }
        
        // Actions
        var _actions = [Action]()
        if let _actionsArray = json[JSONKeys.actions] as? JSONArray {
            for _actionJson in _actionsArray {
                if let _action = ActionFactory.action(json: _actionJson) {
                    _actions.append(_action)
                }
            }
        }
        if !_actions.isEmpty {
            actions = _actions
        }
        else {
            actions = nil
        }
    }
    
    private struct JSONKeys {
        static let id           = "id"
        static let story        = "story"
        static let waypoints    = "waypoints"
        static let actions      = "actions"
        static let cover        = "cover"
    }
}
