//
//  Date.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 28/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

extension Date {

    var startOfDay: Date {
        
        return Calendar.current.startOfDay(for: self)
    }

    func dateEquals(to date: Date) -> Bool {
        
        let d1Start = self.startOfDay
        let d2Start = date.startOfDay
        
        if d1Start.timeIntervalSince(d2Start) == 0.0 {
            
            return true
        }
        
        return false
    }

    var isToday: Bool {
        
        return self.dateEquals(to: Date())
    }
    
}
