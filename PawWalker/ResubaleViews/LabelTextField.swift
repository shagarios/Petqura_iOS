//
//  LabelTextField.swift
//  PawWalker
//
//  Created by shagar on 07/11/24.
//

import SwiftUI

struct LabelTextField: View {
    var label : String
    var placeHolder : String
    var isFullWidth : Bool = false
    var isMobileNumber : Bool = false
    var height : CGFloat = 50
    var borderRadius : CGFloat = 10
    var labelFont : Font = FontConstants.primaryRegularTitle12
    var placeHolderFont : Font = FontConstants.primaryRegularTitle14
    @Binding var text : String
    var keyBoardType : UIKeyboardType = .asciiCapable
    var body: some View {
        VStack(alignment : .leading,spacing: 0) {
            Text(label)
                .foregroundStyle(Color(ColorResource.darkGray))
                .font(labelFont)
                .padding(.leading,5)
                .padding(.bottom,5)
            textFiledView
        }
        .frame(maxWidth : .infinity)
    }
    private var textFiledView : some View {
        HStack(alignment : .center, spacing: 0) {
            if isMobileNumber {
                Text(TextResource.defaultCountryCode)
                    .font(FontConstants.primaryRegularTitle14)
                    .padding(.leading,10)
                   Rectangle()
                    .frame(width : 1, height : 15)
                    .padding(.horizontal, 8)
                    .foregroundStyle(Color(ColorResource.lightGray))
            }
            TextField(placeHolder, text: $text)
                .padding(.leading,isMobileNumber ? 0 : 10)
                .font(placeHolderFont)
                .keyboardType(keyBoardType)
                
        }
        .frame(height : height)
        .if(isFullWidth, transform: { view in
              view
                .frame(maxWidth : .infinity)
        })
        .background(
            RoundedRectangle(cornerRadius: borderRadius)
                .stroke(lineWidth: 1)
                .foregroundStyle(Color(ColorResource.lightGray))
        )
        
    }
}

