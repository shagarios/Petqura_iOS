//
//  SegmentView.swift
//  PawWalker
//
//  Created by shagar on 22/01/25.
//
import SwiftUI

struct SegmentView : View {
    var name : String
    var font : Font = FontConstants.primaryMediumTitle14
    var isSelected : Bool
    var horizontalSpace : CGFloat = 20
    var verticalSpace : CGFloat = 8
    var cornerRadius : CGFloat = 7
    var completion: () -> ()
    var body: some View {
        VStack(spacing : 0) {
            Text(name)
                .font(font)
                .padding(.horizontal,horizontalSpace)
                .padding(.vertical,verticalSpace)
                .foregroundStyle(isSelected ? Color.white : Color.black)
                .background(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundStyle(Color(isSelected ? .primaryButton : .segmentGray))
                )
        }
        .onTapGestureForced {
            completion()
        }
    }
}

struct BorderedSegmentView : View {
    var color : Color
    var height : CGFloat
    var horzontalPadding : CGFloat
    var cornerRadius : CGFloat
    var font : Font
    var text : String
    var body: some View {
        Text(text)
        .foregroundStyle(color)
        .font(font)
        .padding(.horizontal,horzontalPadding)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(lineWidth: 1)
                .foregroundStyle(color)
                .frame(height: 40)
        )

    }
}



