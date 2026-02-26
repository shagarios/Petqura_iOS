//
//  CashFreePGViewController.swift
//  PawWalker
//
//  Created by shagar on 23/03/25.
//

import UIKit
import CashfreePG
import CashfreePGCoreSDK
import CashfreePGUISDK

class CashFreePGViewController : UIViewController,CFResponseDelegate {
    private let payment_session_id: String 
      private let order_id: String
    init(paymentSessionId: String, orderId: String) {
           self.payment_session_id = paymentSessionId
           self.order_id = orderId
           super.init(nibName: nil, bundle: nil)
       }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func onError(_ error: CashfreePGCoreSDK.CFErrorResponse, order_id: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            CashFreeBroker.cashFreeCompletion.send(false)
        })
    }
    func verifyPayment(order_id: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            CashFreeBroker.cashFreeCompletion.send(true)
        })
    }
    
    let pgService = CFPaymentGatewayService.getInstance()
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        self.pgService.setCallback(self)
        
        do {
            let session = try CFSession.CFSessionBuilder()
                .setOrderID(order_id)
                .setPaymentSessionId(payment_session_id)
               .setEnvironment(Bundle.main.scheme == Appscheme.production.rawValue ? .PRODUCTION : .SANDBOX)
                .build()
            let payment = try CFWebCheckoutPayment.CFWebCheckoutPaymentBuilder()
                .setSession(session)
                .build()
            let cfPaymentGateway = CFPaymentGatewayService.getInstance()
            cfPaymentGateway.setCallback(self)
            try self.pgService.doPayment(payment, viewController: self)
        }
        catch let e {
            let err = e as! CashfreeError
                  print(err.description)
        }
    }    
}
