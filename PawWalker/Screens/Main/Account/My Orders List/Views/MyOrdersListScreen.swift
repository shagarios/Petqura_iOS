//
//  MyOrdersListScreen.swift
//  PawWalker
//
//  Created by shagar on 23/03/25.
//

import SwiftUI

struct MyOrdersListScreen: View {
    @StateObject var viewModel = MyOrdersListViewModel()
    @Environment(\.dismiss) var dismiss
    weak var coordinator : AccountCoordinator?
    init(coordinator : AccountCoordinator?) {
        self.coordinator = coordinator
    }
    var body: some View {
        List(viewModel.myOrderList, id: \.orderDetailID) { item in
            MyOrderView(myOrder: item)
                .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .listRowSeparator(.visible)
                .onTapGestureForced {
                    viewModel.selectedProductId = item.productId
                    viewModel.navigateToProductDetail = true
                }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .makeWithLoader(isLoading: $viewModel.isLoading)
        .toolbar(.hidden, for: .tabBar)
        .task {
            viewModel.fetchMyordersList()
        }
        .topBarView(titleView: ViewUtils.shared.titleView(title: TextResource.myOrders),
                    leftButtons: ViewUtils.shared.backButtonView {
            dismiss()
        })
        .navigationDestination(isPresented: $viewModel.navigateToProductDetail) {
            ProductDetailsScreen(viewModel: ProductDetailsViewModel(productId: viewModel.selectedProductId,
                                                                    productMoreUseCase: ProductMoreUseCase(productDetailRepository: ProductDetailRepositoryImplentation()),
                                                                    productDetailUseCase: ProductDetailUseCase(repository: ProductDetailRepositoryImplentation())))
        }
       
    }
}

