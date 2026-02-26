//
//  CashFreeHandler.swift
//  PawWalker
//
//  Created by shagar on 27/03/25.
//
import SwiftUI
import Foundation

struct CashFreeHandler : UIViewControllerRepresentable {
    let paymentSessionId: String
    let orderId: String

    func makeUIViewController(context: Context) ->  UIViewController {
        return CashFreePGViewController(paymentSessionId: paymentSessionId, orderId: orderId)
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
