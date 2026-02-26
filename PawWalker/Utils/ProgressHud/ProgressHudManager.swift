//
//  ProgressHud.swift
//  PawWalker
//
//  Created by shagar on 09/11/24.
//

protocol ProgressHudProtocol {
    func show()
    func dismiss()
    func showError(message : String)
    func showSuccess(message : String)
    func initiliaze()
    func message(message : String)
}

protocol ProgressHudManagerProtocol {
    func show()
    func dismiss()
    func showError(message : String)
    func showSuccess(message : String)
    func message(message : String)
}


final class ProgressHudManager : ProgressHudManagerProtocol {
    func message(message: String) {
        progressHud.message(message: message)
    }
    
    let progressHud : ProgressHudProtocol
    init(progressHud : ProgressHudProtocol) {
        self.progressHud = progressHud
    }
    func show() {
        progressHud.show()
    }
    
    func dismiss() {
        progressHud.dismiss()
    }
    
    func showError(message: String) {
        progressHud.showError(message: message)
    }
    
    func showSuccess(message: String) {
        progressHud.showSuccess(message: message)
    }

}
