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
        
        backgroundColor = UIColor.white.withAlphaComponent(0.5)
        selectionStyle = .none
    }

    func setup(story: String) {
        
        storyLabel.text = story
    }
}
