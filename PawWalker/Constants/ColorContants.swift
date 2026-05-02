//
//  ColorContants.swift
//  PawWalker
//
//  Created by shagar on 19/01/25.
//

import SwiftUI

struct ColorContants {
    let littleGray = Color("littleGray") // Light : F2F2F2 Dark : F2F2F2
    let lightGray =  Color("lightGray") // Light : BDBDBD Dark : F2F2F2
    let darkGray = Color("darkGray") // Light : 7F7F7F Dark : 7F7F7F
    let priceGray = Color("priceGray") //Light: 878787 Dark : 878787
    static let dateGray = Color(lightHex: "#1F120A", darkHex: "#1F120A")
    static let slotGray = Color(lightHex: "#636363", darkHex: "#636363")
    static let inAciveGray = Color(lightHex: "#E7E7E7", darkHex: "#E7E7E7")
    static let billItemNameGray = Color(lightHex: "#797979", darkHex: "#797979")
    static let lightLittleGray = Color(lightHex: "#F3F3F3", darkHex: "#F3F3F3")
    static let bluredBGColor = Color(lightHex: "#455A64", darkHex: "#455A64").opacity(0.80)
    static let dropShadow = Color(lightHex: "#D2D2D2", darkHex: "#D2D2D2")
    static let borderGray = Color(lightHex: "#C7C7C7", darkHex: "#C7C7C7")
    static let softYellow = Color(lightHex: "#FF9900", darkHex: "#FF9900")
}

extension Color {
    static let headerBgGradient = LinearGradient(colors: [Color(lightHex: "#EEF5FF", darkHex: "#EEF5FF"),Color(lightHex: "#D6E7FF", darkHex: "#D6E7FF")], startPoint: .leading, endPoint: .trailing)
    
}
