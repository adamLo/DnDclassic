//
//  Query.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 20/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

class Query {
    
    let action: QueryAction
    
    private(set) var rounds: Int = 0
    
    init(action: QueryAction) {
        
        self.action = action
    }
    
    func check(answer: String) -> Bool {

        rounds += 1
        
        for solution in action.solutions {
            if answer.lowercased() == solution.lowercased() {
                return true
            }
        }
        
        return false
    }
}
