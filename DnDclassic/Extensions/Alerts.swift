//
//  Alerts.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 22/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    class func simpleMessageAlert(message: String, title: String? = nil, canceled: (() -> ())?) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "OK button title"), style: .default, handler: { (_) in
            canceled?()
        }))
        return alert
    }
}
