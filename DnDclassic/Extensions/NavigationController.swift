//
//  NavigationController.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 28/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationController {
    
    var rootViewController: UIViewController? {
        return viewControllers.first
    }
}
