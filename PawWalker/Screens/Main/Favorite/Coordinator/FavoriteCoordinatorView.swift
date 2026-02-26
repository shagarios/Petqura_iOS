//
//  FavoriteCoordinatorView.swift
//  PawWalker
//
//  Created by shagar on 10/11/25.
//

import SwiftUI

struct FavoriteCoordinatorView: View {
    @StateObject var coordinator  = FavoriteCoordinator()
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .favoritePage)
                .navigationDestination(for: FavoritePage.self) { page in
                    coordinator.build(page: page)
                        .toolbar(.hidden, for: .tabBar)
                }
        }
        .onAppear {
            coordinator.appCoordinator = appCoordinator
        }
    }
}
