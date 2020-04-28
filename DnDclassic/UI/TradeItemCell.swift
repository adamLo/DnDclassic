//
//  TradeItemCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 24/04/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class TradeItemCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    
    static let reuseId = "tradeCell"

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        nameLabel.font = UIFont.defaultFont(style: .regular, size: .base)
        nameLabel.textColor = Colors.textDefault
        
        priceLabel.font = UIFont.defaultFont(style: .medium, size: .base)
        priceLabel.textColor = Colors.textDefault
        
        selectionStyle = .gray
        backgroundColor = Colors.panelBackgroundSemiTrans
    }

    func setup(with item: TradeItem) {
        
        nameLabel.text = item.inventoryItem.description
        priceLabel.text = String(format: "%d %@", item.price, Strings.gold)
    }
}
