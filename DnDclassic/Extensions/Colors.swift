//
//  Colors.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 28/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let semiTransparentWhite50 = UIColor.white.withAlphaComponent(0.5)
    static let almostBack = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
}

struct Colors {
        
    static let textDefault          = UIColor.almostBack
    static let textBackground       = UIColor.semiTransparentWhite50
    static let defaultBackground    = UIColor.white
}
