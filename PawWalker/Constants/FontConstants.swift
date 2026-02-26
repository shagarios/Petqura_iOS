//
//  FontConstants.swift
//  PawWalker
//
//  Created by shagar on 06/11/24.
//
import SwiftUI

struct FontNames {
    static let popinsBold = "Poppins-Bold"
    static let poppinsRegular = "Poppins-Regular"
    static let poppinsMedium = "Poppins-Medium"
    static let poppinsBoldItalic = "Poppins-BoldItalic"
    static let poppinsExtraBold = "Poppins-ExtraBold"
    static let poppinsExtraBoldItalic = "Poppins-ExtraBoldItalic"
    static let poppinsExtraLight = "Poppins-ExtraLight"
    static let poppinsExtraLightItalic = "Poppins-ExtraLightItalic"
    static let poppinsItalic = "Poppins-Italic"
    static let poppinsLight = "Poppins-Light"
    static let poppinsLightItalic = "Poppins-LightItalic"
    static let poppinsMediumItalic = "Poppins-MediumItalic"
    static let poppinsSemiBold = "Poppins-SemiBold"
    static let poppinsSemiBoldItalic = "Poppins-SemiBoldItalic"
    static let poppinsThin = "Poppins-Thin"
    static let poppinsThinItalic = "Poppins-ThinItalic"
    
}

struct FontConstants {
    //Regular
    static let primaryRegularTitle30 = Font.custom(FontNames.poppinsRegular, size: 30)
    static let primaryRegularTitle14 = Font.custom(FontNames.poppinsRegular, size: 14)
    static let primaryRegularTitle16 = Font.custom(FontNames.poppinsRegular, size: 16)
    static let primaryRegularTitle15 = Font.custom(FontNames.poppinsRegular, size: 15)
    static let primaryRegularTitle12 = Font.custom(FontNames.poppinsRegular, size: 12)
    static let primaryRegularTitle11 = Font.custom(FontNames.poppinsRegular, size: 11)
    static let primaryRegulatTitle18 = Font.custom(FontNames.poppinsRegular, size: 18)
    
    //Medium
    static let primaryMediumTitle18 = Font.custom(FontNames.poppinsMedium, size: 18)
    static let primaryMediumTitle16 = Font.custom(FontNames.poppinsMedium, size: 16)
    static let primaryMediumTitle14 = Font.custom(FontNames.poppinsMedium, size: 14)
    static let primaryMediumTitle30 = Font.custom(FontNames.poppinsMedium, size: 30)
    static let primaryMediumTitle12 = Font.custom(FontNames.poppinsMedium, size: 12)
    static let primaryMediumTitle11 = Font.custom(FontNames.poppinsMedium, size: 11)
    
    //Bold
    static let primaryBoldTitle30 = Font.custom(FontNames.popinsBold, size: 30)
    static let primarySemiBoldTitle30 = Font.custom(FontNames.poppinsSemiBold, size: 30)
    static let primaryBold12 = Font.custom(FontNames.popinsBold, size: 12)
   
}

struct UIFontConstants {
    static let primaryBoldTitle12 = UIFont(name: FontNames.popinsBold, size: 12)
    static let primaryRegularTitle12 = UIFont(name: FontNames.poppinsRegular, size: 12)
}
