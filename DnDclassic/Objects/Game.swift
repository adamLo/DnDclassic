//
//  Game.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation
import UIKit

struct Game: Deserializable {
    
    let title: String
    let author: String?
    let isbn: String?
    let published: Int?
    let intro: String?
    let cover: UIImage?
    let copyright: String?
    
    let scenes: [Scene]
    
    init?(fileName: String) {
        
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {return nil}
        guard let file = try? Data(contentsOf: url) else {return nil}
        guard let _json = try? JSONSerialization.jsonObject(with: file, options: []) as? JSON else {return nil}
        
        self.init(json: _json)
    }
    
    init?(json: JSON) {
    
        // Title
        guard let _title = json[JSONKeys.title] as? String else {return nil}
        title = _title
        
        // Cover
        if let _imageName = json[JSONKeys.cover] as? String, let _image = UIImage(named: _imageName) {
            cover = _image
        }
        else {
            cover = nil
        }
        
        // Author, ISBN, Published, Intro
        author = json[JSONKeys.author] as? String
        isbn = json[JSONKeys.isbn] as? String
        published = json[JSONKeys.published] as? Int
        intro = json[JSONKeys.intro] as? String
        
        // Scenes
        guard let _scenesArray = json[JSONKeys.scenes] as? JSONArray else {return nil}
        var _scenes = [Scene]()
        for _sceneJson in _scenesArray {
            if let _scene = Scene(json: _sceneJson) {
                _scenes.append(_scene)
            }
        }
        guard !_scenes.isEmpty else {return nil}
        scenes = _scenes
        
        copyright = json[JSONKeys.copyright] as? String
        
        print("*** loaded \(_scenes.count) scenes ***")
    }
    
    var firstScene: Scene? {
        
        return scene(id: 0) ?? scene(id: 1)
    }
    
    func scene(id: Int) -> Scene? {

        return scenes.first { (_scene) -> Bool in
            return _scene.id == id
        }
    }
    
    private struct JSONKeys {
        static let title        = "title"
        static let author       = "author"
        static let isbn         = "isbn"
        static let published    = "published"
        static let intro        = "intro"
        static let cover        = "cover"
        static let scenes       = "scenes"
        static let copyright    = "copyright"
    }
}
