//
//  SVProgressHud.swift
//  PawWalker
//
//  Created by shagar on 09/11/24.
//
import Foundation
import SVProgressHUD
import SwiftUI

class SVProgressHud : ProgressHudProtocol {
    func message(message: String) {
        
    }
    
    func initiliaze() {
    }
    
    func show() {
        DispatchQueue.main.async {
            SVProgressHUD.show()
        }
    }
    func dismiss() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    func showError(message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.showError(withStatus: message)
        }
    }
    func showSuccess(message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.showSuccess(withStatus: message)
        }
    }
    
}

