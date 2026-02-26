//
//  ToastModel.swift
//  PawWalker
//
//  Created by shagar on 22/10/25.
//

import SwiftUI

struct Toast: Identifiable {
    let id = UUID()
    let message: String
    let type: ToastType
}

enum ToastType {
    case success
    case error
    case info

    var backgroundColor: Color {
        switch self {
        case .success: return .green.opacity(0.9)
        case .error: return .red.opacity(0.9)
        case .info: return .black.opacity(0.7)
        }
    }
}
