//
//  CharacterViewInventoryCell.swift
//  DnDclassicTradeItemCell
//
//  Created by Adam Lovastyik on 06/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class CharacterViewInventoryCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    static let reuseId = "inventoryCell"

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
    }

    func setup(item: InventoryWrapper) {
        
        nameLabel.text = (item.item.description) + (item.equipped ? " [\(Localization.equipped)]" : "")
    }

}
