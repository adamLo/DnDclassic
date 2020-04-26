//
//  UIFont+Styling.swift
//  xelion
//
//  Created by Adam Lovastyik on 14/03/2018.
//  Copyright © 2018 xelion. All rights reserved.
//

import Foundation
import UIKit

enum FontStyle: String {
    
    case regular = "-Regular"
    case bold = "-Bold"
    case medium = "-Medium"
    case light = "-Light"
    case italic = "-Italic"
    case condensed = "Condensed-Regular.ttf"
}

enum FontSize {
    
    case xxSmall, xSmall, small, base, large, midLarge, larger, xLarge, xxLarge, xxxLarge
    
    var size: CGFloat {
        
        get {
            
            let portrait = UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown
            let screenWidth =  portrait ? UIScreen.main.bounds.size.width : UIScreen.main.bounds.size.height
            
            var divider: CGFloat = 1.0
            
            switch self {
            
            case .xxSmall: divider = 39.0
            case .xSmall:   divider = 35.0
            case .small:    divider = 31.25
            case .base:     divider = 29.0
            case .large:    divider = 25.0
            case .midLarge: divider = 22.5
            case .larger:   divider = 20.0
            case .xLarge:   divider = 15.0
            case .xxLarge:  divider = 10.0
            case .xxxLarge: divider = 8.0
            }
            
            let calculatedSize = screenWidth / (divider > 0 ? divider : 1.0)

            // We need to increase font size on iPhone 5
            let iPhone5CorrectedSize = screenWidth == 320 ? calculatedSize * 1.15 : calculatedSize
            
            // We need to shrink fonts on iPads
            let iPadCorrectedSize = screenWidth == 768 || screenWidth == 1024 ? iPhone5CorrectedSize * 0.7 : iPhone5CorrectedSize
            
            let consolidatedSize = min(max(iPadCorrectedSize, 5), 100)
            
            return consolidatedSize
        }
    }
}

extension UIFont {
    
    private static let fontFamilyName = "Roboto"
    
    class func defaultFont(style:FontStyle, size: FontSize, scaled: Bool = false) -> UIFont {
        
        let fontName = defaultFontName(style: style)
        
        let fontSize = scaled ? UIFontMetrics.default.scaledValue(for: size.size) : size.size
        
        if let font  = UIFont(name: fontName, size:fontSize) {
            
            return font
        }
        else {
            // Fall back to system font
            return UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    class func printInstalledFonts() {
        
        for family in UIFont.familyNames {
            
            print("\(family)")
            let fam: String = family
            for name in UIFont.fontNames(forFamilyName: fam) {
                print("\t\(name)")
            }
        }
    }
    
    private class func defaultFontName(style: FontStyle) -> String {
        
        let fontName = "\(fontFamilyName)\(style.rawValue)"
        
        return fontName
    }
}
