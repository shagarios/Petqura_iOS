//
//  ViewsModifiers.swift
//  PawWalker
//
//  Created by shagar on 21/01/25.
//

import SwiftUI

struct ItemBorderStyleModifier : ViewModifier {
    let radius : CGFloat
    let spacing : CGFloat
    let shadowRadius : CGFloat
    let bottomShadow : CGFloat
    let shadowColor : Color
    func body(content: Content) -> some View {
        content
            .padding(spacing)
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .foregroundStyle(Color(.white))
                    .shadow(color: shadowColor, radius: shadowRadius,x: 0,y: bottomShadow)
                    
            )
    }
}
extension View {
    func itemBorderStyle(radius : CGFloat = 10,spacing : CGFloat = 10,shadowRadius : CGFloat = 2, bottomShadow : CGFloat = 5,shadowColor : Color = Color(.yellow).opacity(0.8)) -> some View {
        modifier(ItemBorderStyleModifier(radius: radius, spacing: spacing,shadowRadius: shadowRadius,bottomShadow: bottomShadow, shadowColor: shadowColor))
    }
}
struct GradientBorderStyleModifier : ViewModifier {
    let radius : CGFloat
    let spacing : CGFloat
    let shadowRadius : CGFloat
    let bottomShadow : CGFloat
    let shadowColor : Color
    let backgroud: LinearGradient
    func body(content: Content) -> some View {
        content
            .padding(spacing)
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(
                        backgroud
                    )
                    .shadow(color: shadowColor, radius: shadowRadius,x: 0,y: bottomShadow)
                    
            )
    }
}
extension View {
    func gradientBorderStyle(radius : CGFloat = 10,spacing : CGFloat = 10,shadowRadius : CGFloat = 2, bottomShadow : CGFloat = 5,shadowColor : Color = Color(.yellow).opacity(0.8),background : LinearGradient = Color.headerBgGradient) -> some View {
        modifier(GradientBorderStyleModifier(radius: radius, spacing: spacing,shadowRadius: shadowRadius,bottomShadow: bottomShadow, shadowColor: shadowColor, backgroud: background))
    }
}

struct OutlineViewViewModifier : ViewModifier {
    var verticalPadding : CGFloat
    var horzontalPadding : CGFloat
    var cornerRadius : CGFloat
    var outlineColor : Color
    func body(content: Content) -> some View {
        content
        .padding(.vertical,verticalPadding)
        .padding(.horizontal,horzontalPadding)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: 1)
                .foregroundStyle(outlineColor)
        )
    }
}

extension View {
    func applyOutline(
        verticalPadding : CGFloat = 12,
        hortizontalPadding : CGFloat =  20,
        cornerRadius : CGFloat = 15,
        outlineColor : Color = Color.lightGray
    ) -> some View {
        modifier(
            OutlineViewViewModifier(
                verticalPadding: verticalPadding,
                horzontalPadding: hortizontalPadding,
                cornerRadius: cornerRadius,
                outlineColor: outlineColor
            )
        )
    }
}

struct BackgroundModifier : ViewModifier {
    var color : Color
    var horizontalPadding : CGFloat
    var verticalPadding : CGFloat
    var radius : CGFloat
    func body(content: Content) -> some View {
        content
            .padding(.horizontal,horizontalPadding)
            .padding(.vertical,verticalPadding)
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .foregroundStyle(color)
            )
    }
}

extension View {
    func makeBackgroundView(color : Color = Color(ColorResource.littleGray), horizontalPadding : CGFloat = 15, verticalPadding : CGFloat = 20,radius : CGFloat = 10) -> some View {
        modifier(
            BackgroundModifier(
                color: color,
                horizontalPadding: horizontalPadding,
                verticalPadding: verticalPadding,
                radius: radius
            )
        )
    }
}

struct SearchBoxViewModifier : ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 40)
            .font(FontConstants.primaryRegularTitle14)
            //.frame(width: .infinity)
            .padding(.horizontal,12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 1)
                    .foregroundStyle(Color(ColorResource.lightGray))
            )
    }
}

extension View {
    func makeSearchView() -> some View {
        modifier(SearchBoxViewModifier())
    }
}

struct LoaderViewModifier : ViewModifier {
    @Binding var isLoading : Bool
    func body(content: Content) -> some View {
        ZStack {
            LoaderView(isLoading: $isLoading)
            content
        }
    }
}
extension View {
    func makeWithLoader(isLoading: Binding<Bool>) -> some View {
        modifier(LoaderViewModifier(isLoading: isLoading))
    }
}

