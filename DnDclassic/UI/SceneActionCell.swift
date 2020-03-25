//
//  SceneActionTryLuckCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 08/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class SceneActionCell: UITableViewCell {
    
    @IBOutlet weak var captionLabel: UILabel!
    
    static let reuseId = "actionCell"

    override func awakeFromNib() {
        
        super.awakeFromNib()
                
        captionLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }

    func setup(action: Action) {
        
        backgroundColor = UIColor.white
        
        captionLabel.text = action.caption
        
        if let _fight = action as? FightAction, (_fight.isOver || GameData.shared.player == nil || GameData.shared.player.isDead) {
            backgroundColor = UIColor.darkGray
        }
        else if GameData.shared.player == nil || GameData.shared.player.luckCurrent <= 0 {
            backgroundColor = UIColor.darkGray
        }
    }
}
