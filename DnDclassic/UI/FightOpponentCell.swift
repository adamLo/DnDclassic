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
        
        selectionStyle = .gray
        
        nameLabel.font = UIFont.defaultFont(style: .medium, size: .base)
        healthLabel.font = UIFont.defaultFont(style: .regular, size: .base)
        dexterityLabel.font = UIFont.defaultFont(style: .regular, size: .base)
        
        for label in [nameLabel, healthLabel, dexterityLabel] {
            label?.textColor = Colors.textDefault
        }
    }

    func setup(opponent: Opponent) {
        
        nameLabel.text = opponent.name
        
        let healthStatus = Double(opponent.health) / Double(max(opponent.healthStarting, 1)) * 100
        healthLabel.text = Strings.health + ": " + String(format: Strings.displayFormatProperty, opponent.health, opponent.healthStarting, healthStatus)
        
        let dexterityStatus = Double(opponent.dexterity) / Double(max(opponent.dexterityStarting, 1)) * 100
        dexterityLabel.text = Strings.dexterity + ": " + String(format: Strings.displayFormatProperty, opponent.dexterity, opponent.dexterityStarting, dexterityStatus)
        
        backgroundColor = opponent.health > 0 ? UIColor.white : UIColor.darkGray
    }

}
