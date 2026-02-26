//
//  AuthCoordinatorView.swift
//  PawWalker
//
//  Created by shagar on 21/11/25.
//

//import SwiftUI
//
//struct AuthCoordinatorView: View {
//    @StateObject var coordinator  = AuthCoordinator()
//    @EnvironmentObject var appCoordinator: AppCoordinator
//    
//    var body: some View {
//        NavigationStack(path: $coordinator.path) {
//            coordinator.build(page: landingPage)
//                .navigationDestination(for: AuthPage.self) { page in
//                    coordinator.build(page: page)
//                        .toolbar(.hidden, for: .tabBar)
//                }
//        }
//        .onAppear {
//            coordinator.appCoordinator = appCoordinator
//        }
//    }
//    var landingPage : AuthPage {
//        return .register
//       // return UserSessionManager.shared.accessToken.isEmpty ? .register : .map
//    }
//}
