//
//  ProgressHud.swift
//  PawWalker
//
//  Created by shagar on 09/11/24.
//

import Foundation
import ProgressHUD
import UIKit

class ProgressHud : ProgressHudProtocol {
    func message(message: String) {
        DispatchQueue.main.async {
          //  ProgressHUD.banner("", message)
        }
    }
    
    init() {
        initiliaze()
    }
    func show() {
        DispatchQueue.main.async {
            ProgressHUD.animate()
        }
    }
    
    func dismiss() {
        DispatchQueue.main.async {
            ProgressHUD.dismiss()
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            ProgressHUD.failed(message)
        }
    }
    
    func showSuccess(message: String) {
        ProgressHUD.succeed(message)
    }
    
    func initiliaze() {
        DispatchQueue.main.async {
            ProgressHUD.animationType = .circleArcDotSpin
            ProgressHUD.colorAnimation = UIColor(resource: ColorResource.primaryButton)
        }
    }
    
}

class ProgressView : ProgressHudProtocol {
    func show() {
        
    }
    
    func dismiss() {
        
    }
    
    func showError(message: String) {
        
    }
    
    func showSuccess(message: String) {
        
    }
    
    func initiliaze() {
        
    }
    
    func message(message: String) {
        
    }
    
    
}
