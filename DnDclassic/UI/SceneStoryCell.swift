//
//  SceneStoryCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 01/03/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class SceneStoryCell: UITableViewCell {

    @IBOutlet weak var storyLabel: UILabel!
    
    static let reuseId = "storyCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        backgroundColor = Colors.panelBackgroundSemiTrans
        selectionStyle = .none
        
        storyLabel.textColor = Colors.textDefault
        storyLabel.font = UIFont.defaultFont(style: .regular, size: .base)
    }

    func setup(story: String) {
        
        storyLabel.text = story
    }
}
