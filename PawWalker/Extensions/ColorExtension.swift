//
//  ColorExtension.swift
//  PawWalker
//
//  Created by shagar on 29/01/25.
//
import SwiftUI

import SwiftUI

extension Color {
    /// Initializes a Color with separate hex values for light and dark mode
    init(lightHex: String, darkHex: String) {
        self.init(uiColor: UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark
                ? UIColor(hex: darkHex)
                : UIColor(hex: lightHex)
        })
    }
}

// UIColor Extension for Hex Support
extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        
        let a, r, g, b: CGFloat
        switch hex.count {
        case 6: // RGB (No Alpha)
            (a, r, g, b) = (1, CGFloat((int >> 16) & 0xFF) / 255, CGFloat((int >> 8) & 0xFF) / 255, CGFloat(int & 0xFF) / 255)
        case 8: // ARGB
            (a, r, g, b) = (CGFloat((int >> 24) & 0xFF) / 255, CGFloat((int >> 16) & 0xFF) / 255, CGFloat((int >> 8) & 0xFF) / 255, CGFloat(int & 0xFF) / 255)
        default:
            (a, r, g, b) = (1, 0, 0, 0) // Default to black
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
}
