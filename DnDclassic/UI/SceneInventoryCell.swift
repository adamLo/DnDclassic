//
//  SceneInventoryCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class SceneInventoryCell: UITableViewCell {

    @IBOutlet var captionLabel: UILabel!
    
    static let reuseId = "inventoryCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        backgroundColor = Colors.panelBackgroundSemiTrans
        selectionStyle = .gray
        
        captionLabel.textColor = Colors.textDefault
        captionLabel.font = UIFont.defaultFont(style: .medium, size: .base)
    }

    func setup(item: InventoryItem) {
        
        captionLabel.text = item.description
    }

}
