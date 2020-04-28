//
//  LogCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 28/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class LogCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    static let reuseId = "logCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .none
        
        backgroundColor = Colors.panelBackgroundSemiTrans
        
        titleLabel.font = UIFont.defaultFont(style: .regular, size: .base)
        titleLabel.textColor = Colors.textDefault
    }

    func setup(item: LogItem) {
    
        titleLabel.text = item.description
    }

}
