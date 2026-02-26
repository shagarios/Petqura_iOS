//
//  ToastViewModel.swift
//  PawWalker
//
//  Created by shagar on 22/10/25.
//

import Foundation
final class ToastManager: ObservableObject {
    @Published var currentToast: Toast?

    func showToast(message: String, type: ToastType = .info, duration: TimeInterval = 2.0) {
        currentToast = Toast(message: message, type: type)

        // Auto dismiss after duration
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
            self?.currentToast = nil
        }
    }
}

protocol ToastServiceProtocol: AnyObject {
    func showToast(_ message: String, type: ToastType, duration: TimeInterval)
}
final class ToastCenter: ObservableObject, ToastServiceProtocol {
    static let shared = ToastCenter()  // Global instance
    
    @Published private(set) var currentToast: Toast?
    private init() {}

    func showToast(_ message: String, type: ToastType = .info, duration: TimeInterval = 2.0) {
        DispatchQueue.main.async {
            self.currentToast = Toast(message: message, type: type)
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) { [weak self] in
                self?.currentToast = nil
            }
        }
    }
}
