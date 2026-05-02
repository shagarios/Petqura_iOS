//
//  ImageURLView.swift
//  PawWalker
//
//  Created by shagar on 08/02/25.
//

import Kingfisher
import SwiftUI

struct ImageURLView : View {
    var url : String
    var isFill : Bool = false
    var placeHolderImage : String = ""
    var placeHolderSize: (CGFloat, CGFloat) = (0,0)
    var body: some View {
        VStack(spacing: 0){
            KFImage.url(URL(string: url))
                .placeholder({
                    Image(placeHolderImage)
                        .resizable()
                        .frame(width: placeHolderSize.0, height: placeHolderSize.1)
                        .isRemove(placeHolderImage.isEmpty)
                })
                .resizable()
                .aspectRatio(contentMode: isFill ? .fill : .fit)
                .background(Color.clear)
                
        }
    }
}
