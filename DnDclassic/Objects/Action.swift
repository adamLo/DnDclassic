//
//  Action.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 23/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

enum ActionType: String {
    
    case tryLuck, fight, rest, roll, escape, force, propertyRoll, gamble, query, trade
}

class Action: Deserializable {
        
    let type: ActionType
    let condition: Condition?
    
    private let _caption: String?
    var caption: String {
        if let __caption = _caption?.nilIfEmpty {
            return __caption
        }
        switch type {
        case .tryLuck:              return Localization.actionDescriptionTryLuck
        case .fight:                return Localization.actionDescriptionFight
        case .rest:                 return Localization.actionDescriptionRest
        case .roll, .propertyRoll:  return Localization.actionDescriptionRoll
        case .escape:               return Localization.actionDescriptionEscape
        case .force:                return Localization.actionDescriptionForce
        case .gamble:               return Localization.actionDescriptionGamble
        case .query:                return Localization.actionDescriptionQuery
        case .trade:                return Localization.actionDescriptionTrade
        }
    }
    
    required init?(json: JSON) {
        
        guard let _typeString = json[JSONKeys.type] as? String, let _type = ActionType(rawValue: _typeString) else {return nil}
        self.type = _type
        self._caption = json[JSONKeys.caption] as? String
        
        if let _conditionObject = json[JSONKeys.condition] as? JSON {
            guard let _condition = Condition(json: _conditionObject) else {return nil}
            self.condition = _condition
        }
        else {
            self.condition = nil
        }
    }
    
    struct JSONKeys {
        static let type         = "type"
        static let caption      = "caption"
        static let condition    = "condition"
    }
}

class ActionFactory {
    
    class func action(json: JSON) -> Action? {
        
        guard let _typeString = json[Action.JSONKeys.type] as? String, let type = ActionType(rawValue: _typeString) else {return nil}
        
        switch type {
        case .tryLuck:      return TryLuckAction(json: json)
        case .fight:        return FightAction(json: json)
        case .rest:         return RestAction(json: json)
        case .roll:         return RollAction(json: json)
        case .escape:       return EscapeAction(json: json)
        case .force:        return ForceAction(json: json)
        case .propertyRoll: return PropertyRollAction(json: json)
        case .gamble:       return GambleAction(json: json)
        case .query:        return QueryAction(json: json)
        case .trade:        return TradeAction(json: json)
        }
    }
}
