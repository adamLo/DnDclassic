//
//  SceneWaypointCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 01/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class SceneWaypointCell: UITableViewCell {

    @IBOutlet weak var captionTitle: UILabel!
    @IBOutlet weak var directionLabel: UILabel!
    
    static let reuseId = "waypointCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        backgroundColor = UIColor.white.withAlphaComponent(0.95)
        selectionStyle = .gray
    }

    func setup(waypoint: WayPoint) {
        
        captionTitle.text = waypoint.caption
        directionLabel.text = String(format: Strings.messageFormatDirection, waypoint.direction.description, waypoint.destination)
    }

}
