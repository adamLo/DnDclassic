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
        
        // Items, actions
        // FIXME: Load items, actions
        items = nil
        actions = nil
        
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
    }
    
    private struct JSONKeys {
        static let id           = "id"
        static let story        = "story"
        static let waypoints    = "waypoints"
        static let actions      = "actions"
        static let cover        = "cover"
    }
}
