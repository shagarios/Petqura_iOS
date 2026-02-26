//
//  LoaderView.swift
//  PawWalker
//
//  Created by shagar on 24/09/25.
//

import SwiftUI
import ActivityIndicatorView

struct LoaderView : View {
    @Binding var isLoading : Bool
    var body: some View {
        ActivityIndicatorView(isVisible: $isLoading, type: .flickeringDots(count: 8))
            .frame(width: 50.0, height: 50.0)
            .foregroundColor(Color.primaryButton)
    }
}
