//
//  ApplicationExtension.swift
//  PawWalker
//
//  Created by shagar on 08/11/24.
//
import SwiftUI

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    var hasNotch: Bool {
            guard let window = connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .first?.windows
                    .first else {
                return false
            }
            return window.safeAreaInsets.top > 20
        }
}


