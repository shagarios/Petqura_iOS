//
//  CustomPopupAlertView.swift
//  PawWalker
//
//  Created by shagar on 12/08/25.
//


import SwiftUI
import Popovers

struct CustomPopupAlertView<Alert: View>: ViewModifier {
    var alertView: Alert
    @Binding var showWarning: Bool
    var outSideTapEnabled: Bool
    init(alertView: Alert, outSideTap enabled: Bool = true, showWarning: Binding<Bool>) {
        self.alertView = alertView
        self.outSideTapEnabled = enabled
        self._showWarning = showWarning
    }
    
    func body(content: Content) -> some View {
        content
            .popover(present: $showWarning, attributes: {
                $0.blocksBackgroundTouches = true
                $0.rubberBandingMode = .none
                $0.position = .relative(
                    popoverAnchors: [
                        .center,
                    ]
                )
                $0.presentation.animation = .easeOut
                $0.dismissal.mode = .none
                $0.onTapOutside = {
                    withAnimation(.easeIn) {
                        if self.outSideTapEnabled {
                            self.showWarning = false
                        }
                    }
                }
            }) {
                alertView
            } background: {
                Color.black.opacity(0.4)
            }

    }
}

extension View {
    func customPopupAlertView(alertView: any View, showAlert: Binding<Bool>, outSideTap enabled: Bool = true) -> some View {
        modifier(CustomPopupAlertView(alertView: AnyView(alertView), outSideTap: enabled, showWarning: showAlert))
    }
}
