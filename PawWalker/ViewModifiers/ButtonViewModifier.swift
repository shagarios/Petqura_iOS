//
//  ButtonViewModifier.swift
//  PawWalker
//
//  Created by shagar on 05/11/24.
//

import SwiftUI

struct PrimaryButtonModifier : ViewModifier {
    let hight : CGFloat
    let width : CGFloat
    let font : Font
    let foregorundColor : Color
    let backgroundColor : Color
    let fullWidth : Bool
    let active : Bool
    let cornerRadius : CGFloat
    func body(content: Content) -> some View {
            content
                .font(font)
                .frame(height: hight)
                .frame(maxWidth : fullWidth ? .infinity : width)
                .foregroundStyle(foregorundColor)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundStyle(.primaryButton)
                )
                .opacity(active ? 1 : 0.5)
    }
}
extension View {
    func primaryButtonStyle(height : CGFloat = .primaryButtonHeight,width: CGFloat = 100 ,font : Font = FontConstants.primaryMediumTitle16, foregroundColor : Color = .white, backgroundColor : Color = Color.primaryButton,fullWidth: Bool = false,active : Bool = true,cornerRadius: CGFloat = 10) -> some View{
        modifier(PrimaryButtonModifier(hight: height, width: width, font: font, foregorundColor: foregroundColor, backgroundColor: backgroundColor, fullWidth: fullWidth,active: active, cornerRadius: cornerRadius))
    }
}

struct OutlineButtonModifier : ViewModifier {
    let height : CGFloat
    let width : CGFloat
    let font : Font
    let color : Color
    let fullWidth : Bool
    func body(content: Content) -> some View {
            content
                .frame(height: height)
                .frame(maxWidth: fullWidth ? .infinity : width)
                .font(font)
                .foregroundStyle(color)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(color)
                }
    }
}

extension View {
    func outlineButtonStyle(height : CGFloat = .primaryButtonHeight,width:CGFloat = 100,  font : Font = FontConstants.primaryMediumTitle16,color : Color = .primaryButton, fullWidth : Bool = false) -> some View {
        modifier(OutlineButtonModifier(height: height, width: width, font: font, color: color, fullWidth: fullWidth))
    }
}
