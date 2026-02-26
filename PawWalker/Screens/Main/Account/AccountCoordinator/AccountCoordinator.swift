//
//  AccountCoordinator.swift
//  PawWalker
//
//  Created by shagar on 10/11/25.
//

import SwiftUI

enum AccountPages : Hashable {
    case myAccount
    case myAddressList
    case myAppointments
    case myOrders
    case addNewAddress(isEdit : Bool, address: Address?)
    case register
    case otp(mobileNo: String,firstName: String,email: String)
    case location(isAccountRelated: Bool = false, address : Address? = nil)
}

class AccountCoordinator : ObservableObject {
    @Published var path = NavigationPath()
    weak var appCoordinator: AppCoordinator?
    func push(_ page: AccountPages) {
        path.append(page)
    }
    func pop() {
        if path.count > 0 {
            path.removeLast()
        }
    }
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(page: AccountPages) -> some View {
        switch page {
        case .myAccount:
            MyAccountScreen(coordinator: self)
        case .myAddressList:
            MyAddressListScreen(coordinator: self)
        case .myAppointments:
            MyAppointmentListScreen(coordinator: self)
        case .addNewAddress(let isEdit, let address):
            NewAddressScreen(isEdit: isEdit,address: address,coordinator: self)
        case .myOrders:
            MyOrdersListScreen(coordinator: self)
        case .register:
            MobileNumberRegistrationView(coordinator: self)
        case .otp(let mobile,let firstName,let email):
            OtpScreen(mobileNumber: mobile, coordinator: self,firstName: firstName,email: email)
        case .location(let isAccountRelated,let address):
            MapScreen(address: address, isAccountRelated: isAccountRelated, coordinator: self)
        }
    }
    
//    func startAt(route: AccountPages) {
//        // This method gets called when coming from another tab
//        path.removeLast(path.count) // reset path if needed
//        path.append(route)
//    }
    func moveToMyOrders() {
        push(.myAppointments)
    }
}
