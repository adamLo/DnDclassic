//
//  Action.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

enum ActionType: String {
    
    case tryLuck, fight, rest
}

class Action: Deserializable {
        
    let type: ActionType
    let caption: String?
    
    required init?(json: JSON) {
        
        guard let _typeString = json[JSONKeys.type] as? String, let _type = ActionType(rawValue: _typeString) else {return nil}
        self.type = _type
        self.caption = json[JSONKeys.caption] as? String
    }
    
    struct JSONKeys {
        static let type     = "type"
        static let caption  = "caption"
    }
}

class ActionFactory {
    
    class func action(json: JSON) -> Action? {
        
        guard let _typeString = json[Action.JSONKeys.type] as? String, let type = ActionType(rawValue: _typeString) else {return nil}
        
        switch type {
        case .tryLuck: return TryLuckAction(json: json)
        case .fight: return FightAction(json: json)
        case .rest: return RestAction(json: json)
        }
    }
}
