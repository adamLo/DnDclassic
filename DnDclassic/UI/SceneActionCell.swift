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

        backgroundColor = Colors.panelBackgroundSemiTrans
        selectionStyle = .gray
        
        captionLabel.font = UIFont.defaultFont(style: .medium, size: .base)
    }

    func setup(action: Action) {
        
        captionLabel.text = action.caption
        
        if let _fight = action as? FightAction, (_fight.isOver || GameData.shared.player == nil || GameData.shared.player.isDead) {
            backgroundColor = Colors.disabledItemBackground
            captionLabel.textColor = Colors.textOnDarkBackground
        }
        else if GameData.shared.player == nil || GameData.shared.player.luck <= 0 {
            backgroundColor = Colors.disabledItemBackground
            captionLabel.textColor = Colors.textOnDarkBackground
        }
        else {
            captionLabel.textColor = Colors.textDefault
        }
    }
}
