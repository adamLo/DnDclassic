//
//  CharacterEditPropertyCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 26/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class CharacterEditPropertyCell: UITableViewCell {

    static let reuseId = "characterPropertyCell"
    
    @IBOutlet weak var propertyNameLabel: UILabel!
    @IBOutlet weak var propertyValueLabel: UILabel!
    @IBOutlet weak var rollButton: UIButton!
    
    var rollTouched: (() -> ())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = Colors.panelBackgroundSemiTrans
        
        rollButton.setTitle(Strings.roll, for: .normal)
        rollButton.setTitleColor(Colors.buttonTitleDefault, for: .normal)
        rollButton.titleLabel?.font = UIFont.defaultFont(style: .medium, size: .base)
        
        for label in [propertyNameLabel, propertyValueLabel] {
            label?.textColor = Colors.textDefault
            label?.font = UIFont.defaultFont(style: .regular, size: .base)
        }
    }

    func setup(type: CharacterProperty, value: Int) {
        
        propertyNameLabel.text = type.rawValue
        propertyValueLabel.text = value > 0 ? "\(value)" : nil
    }

    @IBAction func rollButtonTouched(_ sender: Any) {
        
        rollTouched?()
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        rollTouched = nil
    }
}
