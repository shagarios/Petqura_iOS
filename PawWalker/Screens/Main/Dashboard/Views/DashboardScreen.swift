//
//  DashboardScreen.swift
//  PawWalker
//
//  Created by shagar on 08/12/24.
//

import SwiftUI

struct DashboardScreen: View {
    @StateObject var viewModel = DashboardViewModel()
    @EnvironmentObject var appCoordinator : AppCoordinator
    var body: some View {
        VStack {
            tabView
        }
        .onChange(of: appCoordinator.navigateToAppointmentDetailsScreen) { newValue in
            if newValue {
                appCoordinator.selectedTab = .clinic
            }
        }
//        .task {
//            await viewModel.fetchBasicInfo()
//        }
//        .navigationDestination(isPresented: $viewModel.navigateToCart) {
//            CartDeatilsScreen {
//                viewModel.navigateToCart = false
//                viewModel.selection = .store
//            } payementCompletion: {
//                viewModel.navigateToCart = false
//                viewModel.selection = .account
//                viewModel.navigateToMyorder = true
//            }
//        }
    }

    private var tabView : some View {
        TabView(selection: $appCoordinator.selectedTab) {
            HomeCoordinatorView()
                .tabItem {
                    Image(.homeIcon)
                       // .foregroundStyle(viewModel.selection == .home ? .primaryButton : .darkGray)
                    Text(TextResource.home)
                }
                .tag(TabBarItems.home)
                .environmentObject(appCoordinator)
            ClinicCoordinatorView()
                .environmentObject(appCoordinator)
                .tabItem {
                    Image(.clinicIcon)
                    Text(TextResource.clinic)
                        .font(FontConstants.primaryMediumTitle14)
                }
                .tag(TabBarItems.clinic)
                 FavoriteCoordinatorView()
                    .tabItem {
                        Image(.favouritesIcon)
                        Text(TextResource.favourites)
                    }
                    .tag(TabBarItems.favourites)
                    .environmentObject(appCoordinator)
           
       //     ProductListScreen(categoryId: $viewModel.selectedCategoryId)
            productComingSoonView
                .tabItem {
                    Image(ImageResource.storeIcon)
                    Text(TextResource.store)
                        .font(FontConstants.primaryMediumTitle14)
                }
                .tag(TabBarItems.store)
         
            AccountCoordinatorView()
                .tabItem {
                    Image(.accountIcon)
                    Text(TextResource.account)
                }
                .environmentObject(appCoordinator)
                .tag(TabBarItems.account)
        }
        .tint(.primaryButton)
    }
    private var productComingSoonView : some View {
        VStack {
            Spacer()
            Image(.cartEmpty)
            Text(TextResource.petProductsComingSoon)
                .padding(.top, -50)
            Spacer()
        }
        .topBarView(titleView: appCoordinator.titleView())
    }

}



#Preview {
    DashboardScreen()
}
