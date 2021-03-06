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
    
    class func simpleMessageAlert(message: String, title: String? = nil, canceled: (() -> ())? = nil) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
        alert.addAction(UIAlertAction(title: Strings.buttonTitleOk, style: .default, handler: { (_) in
            canceled?()
        }))
        return alert
    }
}

extension UIAlertAction {
    
    class func cancelAction(title: String? = nil, selected: (() -> ())? = nil) -> UIAlertAction {
        
        let action = UIAlertAction(title: title ?? Strings.buttonTitleCancel, style: .cancel) { (_) in
            selected?()
        }
        
        return action
    }
    
    class func OKAction(title: String? = nil, selected: (() -> ())? = nil) -> UIAlertAction {
        
        let action = UIAlertAction(title: title ?? Strings.buttonTitleOk, style: .default) { (_) in
            selected?()
        }
        
        return action
    }
}
