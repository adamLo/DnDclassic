//
//  CharacterEditInventoryItemCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 26/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class CharacterEditInventoryItemCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    
    static let reuseId = "characterInventoryCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    func setup(item: InventoryItem) {
        
        itemNameLabel.text = item.description
    }

}
