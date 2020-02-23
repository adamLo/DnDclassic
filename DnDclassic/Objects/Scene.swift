//
//  Scene.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation
import UIKit

struct Scene {
    
    let id: Int
    let story: String
    let image: UIImage?
    
    let wayPoints: [WayPoint]
    var items: [InventoryItem]
    let actions: [Action]
    
    init(id: Int, story: String, image: UIImage? = nil, wayPoints: [WayPoint]? = nil, items: [InventoryItem]? = nil, actions: [Action]? = nil) {
        
        self.id = id
        self.story = story
        self.image = image
        
        self.wayPoints = wayPoints ?? []
        self.items = items ?? []
        self.actions = actions ?? []
    }
}
