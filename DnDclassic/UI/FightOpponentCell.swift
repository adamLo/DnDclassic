//
//  FightOpponentCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 21/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class FightOpponentCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var healthLabel: UILabel!
    @IBOutlet var dexterityLabel: UILabel!    

    static let reuseId = "opponentCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }

    func setup(opponent: Opponent) {
        
        nameLabel.text = opponent.name
        
        let healthStatus = Double(opponent.healthCurrent) / Double(max(opponent.healthStarting, 1)) * 100
        healthLabel.text = NSLocalizedString("Health", comment: "Health title") + ": " + String(format: NSLocalizedString("%d of %d - %0.0f%%", comment: "Character property display format"), opponent.healthCurrent, opponent.healthStarting, healthStatus)
        
        let dexterityStatus = Double(opponent.dexterityCurrent) / Double(max(opponent.dexterityStarting, 1)) * 100
        dexterityLabel.text = NSLocalizedString("Dexterity", comment: "Dexterity title") + ": " + String(format: NSLocalizedString("%d of %d - %0.0f%%", comment: "Character property display format"), opponent.dexterityCurrent, opponent.dexterityStarting, dexterityStatus)
        
        backgroundColor = opponent.healthCurrent > 0 ? UIColor.white : UIColor.darkGray
    }

}
