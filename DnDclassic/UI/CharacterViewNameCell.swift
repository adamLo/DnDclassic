//
//  CharacterViewNameCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 06/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class CharacterViewNameCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
        
    static let reuseId = "nameCell"

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        nameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        selectionStyle = .none
    }

    func setup(name: String) {
        
        nameLabel.text = name
    }

}
