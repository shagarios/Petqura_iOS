//
//  AppCoordinatorVIew.swift
//  PawWalker
//
//  Created by shagar on 09/11/25.
//

import SwiftUI
struct AppCoordinatorView : View {
    @StateObject private var appCoordinator = AppCoordinator()
    var body: some View {
        Group{
            switch appCoordinator.flow {
     //       case .auth:
//                    AuthCoordinatorView()
//                    .environmentObject(appCoordinator)
            case .dashboard:
                DashboardScreen()
                    .environmentObject(appCoordinator)
            }
        }
    }
}

enum Flow {
  //  case auth
    case dashboard
}

