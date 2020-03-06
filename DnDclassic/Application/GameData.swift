//
//  GameData.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class GameData {
    
    static let shared = GameData()
    
    var player: Character!
    var game: Game!
    var currentSceneId = 0
    
    func advance(player: Character, scene: Scene) {
        
        player.advance(to: scene)
        currentSceneId = scene.id        
    }
}
