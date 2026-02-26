//
//  ViewUtils.swift
//  PawWalker
//
//  Created by shagar on 06/02/25.
//

import SwiftUI

struct ViewUtils {
    static let shared = ViewUtils()
    
    func titleView(title: String) -> some View {
        Text(title)
            .font(FontConstants.primaryMediumTitle16)
            .foregroundStyle(Color(ColorResource.primaryButton))
    }
    
    func backButtonView(action : @escaping () -> ()) -> some View {
        Button(action: {
            action()
        }, label: {
            Image(ImageResource.backButtonGray)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .tint(Color(ColorResource.primaryButton))
                .frame(width: 24,height: 20)
        })
    }
    func  cartButtonView(count : Int, action : @escaping () -> ()) -> some View {
        Button(action: {
            action()
        }, label: {
            Image(.cartIcon)
                .resizable()
                .frame(width: 30,height: 30)
                .if(count > 0, transform: { view in
                    view
                        .customBadge(count : count)
                })
                
        })
    }

}
