//
//  MyOrdersListScreen.swift
//  PawWalker
//
//  Created by shagar on 23/03/25.
//

import SwiftUI

struct MyOrdersListScreen: View {
    @StateObject var viewModel = MyOrdersListViewModel()
    weak var coordinator : AccountCoordinator?
    init(coordinator : AccountCoordinator) {
        self.coordinator = coordinator
    }
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(viewModel.myOrderList,id: \.self) {item in
                    MyOrderView(myOrder: item)
                        .padding(.top,10)
                    Divider()
                }
            }
            .padding(.horizontal,20)
        }
        .makeWithLoader(isLoading: $viewModel.isLoading)
        .task {
            viewModel.fetchMyordersList()
        }
        .topBarView(titleView: ViewUtils.shared.titleView(title: TextResource.myOrders),
                    leftButtons: ViewUtils.shared.backButtonView {
            coordinator?.pop()
        })
    }
}

