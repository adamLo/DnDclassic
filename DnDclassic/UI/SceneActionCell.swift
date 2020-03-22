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
        
        if let _caption = action.caption?.nilIfEmpty {
            captionLabel.text = _caption
        }
        else if action.type == .tryLuck {
            captionLabel.text = NSLocalizedString("Try your luck!", comment: "Try luck action cell caption title")
        }
        else if action.type == .fight {
            captionLabel.text = NSLocalizedString("Fight!", comment: "Fight action cell caption title")
        }
        else if action.type == .rest {
            captionLabel.text = NSLocalizedString("Get some rest", comment: "Restaction cell caption title")
        }
        
        if let _fight = action as? FightAction, (_fight.isOver || GameData.shared.player == nil || GameData.shared.player.isDead) {
            backgroundColor = UIColor.darkGray
        }
        else if GameData.shared.player == nil || GameData.shared.player.luckCurrent <= 0 {
            backgroundColor = UIColor.darkGray
        }
    }
}
