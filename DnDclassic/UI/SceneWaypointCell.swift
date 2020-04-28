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
        
        backgroundColor = Colors.panelBackgroundSemiTrans
        selectionStyle = .gray
        
        captionTitle.font = UIFont.defaultFont(style: .medium, size: .base)
        captionTitle.textColor = Colors.textDefault
        
        directionLabel.font = UIFont.defaultFont(style: .light, size: .xSmall)
        directionLabel.textColor = Colors.textDefault
    }

    func setup(waypoint: WayPoint) {
        
        captionTitle.text = waypoint.caption
        directionLabel.text = String(format: Strings.messageFormatDirection, waypoint.direction.description, waypoint.destination)
    }

}
