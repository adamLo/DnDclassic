//
//  SceneWaypointCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 01/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class SceneWaypointCell: UITableViewCell {

    
    static let reuseId = "waypointCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    func setup(waypoint: WayPoint) {
        
    }

}
