//
//  ImageTextView.swift
//  PawWalker
//
//  Created by shagar on 22/01/25.
//

import SwiftUI


struct ImageTextView : View {
    let image : ImageResource
    let text : String
    let imageWidth : CGFloat = 14
    let imageHeight : CGFloat = 14
    var body: some View {
        HStack {
            Image(image)
                .resizable()
                .frame(width: imageWidth,height: imageHeight)
            Text(text)
                .font(FontConstants.primaryRegularTitle12)
        }
    }
}

