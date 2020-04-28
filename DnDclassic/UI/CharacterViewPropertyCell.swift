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
        backgroundColor = Colors.panelBackgroundSemiTrans
        
        for label in [nameLabel, valueLabel] {
            label?.textColor = Colors.textDefault
            label?.font = UIFont.defaultFont(style: .regular, size: .base)
        }
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
        
        valueLabel.text = String(format: Strings.displayFormatProperty, currentValue, startValue, status)
    }

}
