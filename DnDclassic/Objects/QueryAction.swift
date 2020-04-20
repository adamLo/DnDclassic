//
//  QueryAction.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 20/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class QueryAction: Action {
    
    let solutions: [String]
    let cancel: WayPoint

    required init?(json: JSON) {
        
        guard let _solutions = json[JSONkeys.solutions] as? [String], !_solutions.isEmpty else {return nil}
        solutions = _solutions
        
        guard let _cancelJson = json[JSONkeys.cancel] as? JSON, let _cancel = WayPoint(json: _cancelJson) else {return nil}
        cancel = _cancel
        
        super.init(json: json)
    }
    
    private struct JSONkeys {
        static let solutions    = "solutions"
        static let cancel       = "cancel"
    }
}
