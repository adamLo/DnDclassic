//
//  CharacterEditPotionCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 26/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class CharacterEditPotionCell: UITableViewCell {

    @IBOutlet weak var potionTitleLabel: UILabel!
    @IBOutlet weak var potionNameLabel: UILabel!
    @IBOutlet weak var changeButton: UIButton!
    
    static let reuseId = "characterPotionCell"
    
    var changeTouched: (() -> ())?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .none
        potionTitleLabel.text = Strings.potion
    }
    
    func setup(type: CharacterProperty?) {
        
        potionNameLabel.text = type?.rawValue ?? nil
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
