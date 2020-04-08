//
//  CharacterViewPropertyCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 06/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class CharacterViewPropertyCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    static let reuseId = "propertyCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        selectionStyle = .none
    }

    func setup(character: Character, property: CharacterProperty) {
        
        nameLabel.text = property.rawValue
        
        var currentValue = 0
        var startValue = 0
        var status: Double = 0
        
        switch property {
        case .dexterity:
            currentValue = character.dexterity
            startValue = character.dexterityStarting
        case .health:
            currentValue = character.health
            startValue = character.healthStarting
        case .luck:
            currentValue = character.luck
            startValue = character.luckStarting
        }
        
        if startValue > 0 {
            status = Double(currentValue) / Double(startValue) * 100
        }
        
        valueLabel.text = String(format: NSLocalizedString("%d of %d - %0.0f%%", comment: "Character property display format"), currentValue, startValue, status)
    }

}
