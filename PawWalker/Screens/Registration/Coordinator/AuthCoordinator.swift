//
//  AuthCoordinator.swift
//  PawWalker
//
//  Created by shagar on 20/11/25.
//

import SwiftUI
enum AuthPage : Hashable {
    case register
    case otp(mobileNo: String)
 //   case map
}

class AuthCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    weak var appCoordinator: AppCoordinator?
    func push(_ page: AuthPage) {
        path.append(page)
    }
    func pop() {
        path.removeLast()
    }
    func popToRoot() {
        path.removeLast(path.count)
    }
    
//    @ViewBuilder
//    func build(page: AuthPage) -> some View {
//        switch page {
//        case .register:
//            MobileNumberRegistrationView(coordinator: self)
//        case .otp(let mobile):
//            OtpScreen(mobileNumber: mobile, coordinator: self)
////        case .map:
////            MapScreen(coordinator: self)
//        }
//    }
}
