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
    var body: some View {
        VStack(spacing: 0){
            KFImage.url(URL(string: url))
                .resizable()
                .aspectRatio(contentMode: isFill ? .fill : .fit)
                .background(Color.clear)
        }
    }
}
