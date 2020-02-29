//
//  Strings.swift
//  DnDclassic
//
//  Created by Adam Lovastyik on 29/02/2020.
//  Copyright © 2020 Adam Lovastyik. All rights reserved.
//

import Foundation

extension String {

    var trimmed: String {
        get {
            return self.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    var nilIfEmpty: String? {
        get {
            let _trimmed = self.trimmed
            return _trimmed.isEmpty ? nil : _trimmed
        }
    }
}
