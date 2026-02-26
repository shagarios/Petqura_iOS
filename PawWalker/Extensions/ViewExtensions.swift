//
//  ViewExtensions.swift
//  PawWalker
//
//  Created by shagar on 05/11/24.
//
import Foundation
import SwiftUI

extension View {
    @ViewBuilder func isRemove(_ remove : Bool = false) -> some View {
        if !remove {
            self
        }
    }
    @ViewBuilder func isHidden(_ hidden : Bool) -> some View {
        if hidden {
            self.hidden()
        }
        else {
            self
        }
    }
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    func onTapGestureForced (perform  action: @escaping () -> Void) -> some View {
        self
            .contentShape(Rectangle())
            .onTapGesture {
                action()
            }
    }
}
