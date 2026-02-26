//
//  HomeCoordinatorView.swift
//  PawWalker
//
//  Created by shagar on 10/11/25.
//

import SwiftUI

struct HomeCoordinatorView: View {
    @StateObject var coordinator  = HomeCoordinator()
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .home)
                .navigationDestination(for: HomePages.self) { page in
                    coordinator.build(page: page)
                        .toolbar(.hidden, for: .tabBar)
                }
        }
        .onAppear {
            coordinator.appCoordinator = appCoordinator
        }
    }
}
