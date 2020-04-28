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
        
        passSceneData()
        setupUI()
    }

    private func setupUI() {
        
        let attributesNormal = [NSAttributedString.Key.foregroundColor: Colors.textDefault, NSAttributedString.Key.font: UIFont.defaultFont(style: .regular, size: .base)]
        let attributesSelected = [NSAttributedString.Key.foregroundColor: Colors.textDefault, NSAttributedString.Key.font: UIFont.defaultFont(style: .medium, size: .base)]
        
        UITabBarItem.appearance().setTitleTextAttributes(attributesNormal, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
    }
    
    private func passSceneData() {
        
        if let _controllers = viewControllers {
            for viewController in _controllers {
                if let sceneViewcontroller = viewController as? SceneViewController {
                    sceneViewcontroller.scene = scene
                }
            }
        }
    }
}
