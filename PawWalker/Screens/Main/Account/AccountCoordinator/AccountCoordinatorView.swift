//
//  AccountCoordinatorView.swift
//  PawWalker
//
//  Created by shagar on 10/11/25.
//

import SwiftUI

struct AccountCoordinatorView: View {
    @StateObject var coordinator  = AccountCoordinator()
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .myAccount)
                .navigationDestination(for: AccountPages.self) { page in
                    coordinator.build(page: page)
                        .if(page != .myAccount, transform: { view in
                                view
                                .toolbar(.hidden, for: .tabBar)
                        })
                         // hides for all pushed views
                }
        }
        .onAppear {
            coordinator.appCoordinator = appCoordinator
            DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
//                if appCoordinator.navigateToMyOrders {
                    coordinator.popToRoot()
                    coordinator.push(appCoordinator.selectedAccountPage)
                   appCoordinator.selectedAccountPage = .myAccount
          //  }
            })
        }
    }
}
