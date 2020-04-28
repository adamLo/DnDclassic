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
    static let semiTransparentWhite90 = UIColor.white.withAlphaComponent(0.9)
    
    static let almostBack = UIColor(red: 5/255, green: 5/255, blue: 5/255, alpha: 1.0)
    
    static let midGray = UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 1.0)
    static let veryLightGray = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
}

struct Colors {
        
    static let textDefault              = UIColor.almostBack
    static let textBackground           = UIColor.semiTransparentWhite50
    static let textOnDarkBackground     = UIColor.veryLightGray
    static let defaultBackground        = UIColor.white
    static let panelBackgroundSemiTrans = UIColor.semiTransparentWhite90
    static let panelBackgroundOpaque    = UIColor.white
    static let disabledItemBackground   = UIColor.midGray
}
