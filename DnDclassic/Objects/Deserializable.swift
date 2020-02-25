//
//  Deserializable.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 25/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

protocol Deserializable {
    
    init?(json: JSON)
}
