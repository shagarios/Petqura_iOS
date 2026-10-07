//
//  AppCoordinatorView 3.swift
//  PawWalker
//
//  Created by shagar on 15/09/26.
//



import SwiftUI
struct AppCoordinatorView : View {
    @StateObject private var appCoordinator = AppCoordinator()
    var body: some View {
        Group{
            switch appCoordinator.flow {
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
