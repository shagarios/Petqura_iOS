//
//  UIDeviceExtension.swift
//  PawWalker
//
//  Created by shagar on 08/12/24.
//
import Foundation
import UIKit

extension UIDevice {
    var hasNotch: Bool {
        if #available(iOS 11.0, *) {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            return keyWindow?.safeAreaInsets.bottom ?? 0 > 0
        }
        return false
    }
    func topPaddingForStatusBar() -> CGFloat {
        return UIDevice.current.hasNotch ? .paddingTopWithNotch : .paddingTopWithoutNotch
    }
}
