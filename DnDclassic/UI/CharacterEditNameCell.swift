//
//  CharacterEditNameCell.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 26/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import UIKit

class CharacterEditNameCell: UITableViewCell {
    
    @IBOutlet weak var nameTextField: UITextField!
    
    var nameChanged: ((_ newValue: String?) -> ())?
    
    static let reuseId = "characterNameCell"
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        selectionStyle = .none
        
        nameTextField.attributedPlaceholder = NSAttributedString(string: Strings.name, attributes: [NSAttributedString.Key.font: UIFont.defaultFont(style: .regular, size: .base), NSAttributedString.Key.foregroundColor: Colors.textFieldPlaceholder]) 
        nameTextField.font = UIFont.defaultFont(style: .regular, size: .base)
    }
    
    func setup(name: String?) {
        
        nameTextField.text = name
    }

    @IBAction func nameEditChanged(_ sender: UITextField) {
        
        nameChanged?(sender.text)
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()
        nameChanged = nil
    }
}
