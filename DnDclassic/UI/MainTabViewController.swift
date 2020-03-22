//
//  MainTabViewController.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 22/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class MainTabViewController: UITabBarController {
    
    var scene: Scene!
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let _controllers = viewControllers {
            for viewController in _controllers {
                if let sceneViewcontroller = viewController as? SceneViewController {
                    sceneViewcontroller.scene = scene
                }
            }
        }
    }

}
