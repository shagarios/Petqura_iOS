//
//  EventHandler.swift
//  PawWalker
//
//  Created by shagar on 12/02/25.
//

import Combine

class EventHandler {
    static var cartCountSubject = PassthroughSubject<Int,Never>()
    static var productIdentitySubject = PassthroughSubject<ProductIdentity,Never>()
    static var productListNavigationSubject = PassthroughSubject<Bool,Never>()
    static var loginNavigationSubject = PassthroughSubject<Void,Never>()
    static var MyAddressListNavigationSubject = PassthroughSubject<Void,Never>()
    static var myOrderNavigationSubject = PassthroughSubject<Void,Never>()
}
