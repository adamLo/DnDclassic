//
//  CharacterEditPotionCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 26/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class CharacterEditPotionCell: UITableViewCell {

    @IBOutlet weak var potionNameLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    static let reuseId = "characterPotionCell"
    
    var changeTouched: (() -> ())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .none
        backgroundColor = Colors.panelBackgroundSemiTrans
        
        changeButton.setTitleColor(Colors.buttonTitleDefault, for: .normal)
        changeButton.titleLabel?.font = UIFont.defaultFont(style: .medium, size: .base)
        
        potionNameLabel.textColor = Colors.textDefault
        potionNameLabel.font = UIFont.defaultFont(style: .regular, size: .base)        
    }
    
    func setup(type: CharacterProperty?) {
        
        if let _type = type {
            switch _type {
            case .dexterity: potionNameLabel.text = Strings.titlePotionDexterity
            case .health: potionNameLabel.text = Strings.titlePotionHealth
            case .luck: potionNameLabel.text = Strings.titlePotionLuck
            }
        }
        else {
            potionNameLabel.text = nil
        }

        changeButton.setTitle(type == nil ? Strings.buttonTitleAdd : Strings.buttonTitleChange, for: .normal)
    }

    @IBAction func changeButtonTouched(_ sender: Any) {
        
        changeTouched?()
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        changeTouched = nil
    }
}
