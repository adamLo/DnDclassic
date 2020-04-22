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
    private(set) var completedScenes = [Int]()
    
    func advance(player: Character, scene: Scene) {
        
        player.advance(to: scene)
        currentSceneId = scene.id
    }
    
    func isCompleted(scene: Scene) -> Bool {
        return completedScenes.firstIndex(of: scene.id) != nil
    }
    
    func isCompleted(sceneId: Int) -> Bool {
        return completedScenes.firstIndex(of: sceneId) != nil
    }
    
    func completed(scene: Scene) {
        
        if !isCompleted(scene: scene) {
            completedScenes.append(scene.id)
        }
    }
    
    func reset() {
        
        currentSceneId = 0
        completedScenes.removeAll()
    }
}
