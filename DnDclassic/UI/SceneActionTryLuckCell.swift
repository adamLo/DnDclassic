//
//  SceneActionTryLuckCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 08/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class SceneActionTryLuckCell: UITableViewCell {
    
    @IBOutlet weak var captionLabel: UILabel!
    
    static let reuseId = "tryLuckCell"

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        captionLabel.text = NSLocalizedString("Try your luck!", comment: "Try luck cell caption title")
        captionLabel.font = UIFont.boldSystemFont(ofSize: 18)
    }

}
