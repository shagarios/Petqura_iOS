//
//  ToastView.swift
//  PawWalker
//
//  Created by shagar on 22/10/25.
//

import SwiftUI
struct ToastView: View {
    let toast: Toast

    var body: some View {
        Text(toast.message)
            .font(.system(size: 15, weight: .medium))
            .foregroundColor(.white)
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background(toast.type.backgroundColor)
            .transition(.move(edge: .top).combined(with: .opacity))
            .animation(.spring(), value: toast.id)
    }
}

struct GlobalToastPresenter<Content: View>: View {
    @StateObject private var toastCenter = ToastCenter.shared
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            content
            if let toast = toastCenter.currentToast {
                VStack {
                    Spacer()
                    ToastView(toast: toast)
                        .padding(.bottom, 10)
                        .padding(.horizontal,20)
                }
                .transition(.slide)
            }
        }
    }
}
