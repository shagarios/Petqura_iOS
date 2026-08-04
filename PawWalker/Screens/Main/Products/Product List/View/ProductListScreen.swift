//
//  ProductListScreen.swift
//  PawWalker
//
//  Created by shagar on 18/01/25.
//

import SwiftUI
struct ProductListScreen: View {
    @StateObject var viewModel = ProductListViewModel()
    @EnvironmentObject var appCoordinator: AppCoordinator
    @Binding var categoryId : String
    let colomns : [GridItem] = [GridItem(.flexible(minimum: 100, maximum: 160),spacing: 20),
                                GridItem(.flexible(minimum: 100, maximum: 160))]
    var body: some View {
            VStack {
                topView
                    .padding(.horizontal,20)
                    .padding(.top,10)
                if viewModel.shouldShowEmptyView {
                    emptyProductView
                }
                else {
                    if viewModel.shouldShowEmptySearchView {
                        emptyProductViewForSearch
                    }
                    else {
                        productListView
                    }
                }
            }
        .onAppear{
            viewModel.shouldShowEmptyView = false
            viewModel.shouldShowEmptySearchView = false
            viewModel.categoryId = self.categoryId
            viewModel.page = 1
            viewModel.searchText = ""
        }
        .task {
            if  self.categoryId.isEmpty {
                viewModel.fetchPoductList(categoryId: "")
            }
        }
        .task {
            viewModel.fetchCartList()
        }
        .makeWithLoader(isLoading: $viewModel.isLoading)
        .onChange(of: categoryId, perform: { newValue in
            viewModel.fetchPoductList(categoryId: self.categoryId)
        })
        .navigationDestination(isPresented: $viewModel.navigateToProductDetail) {
           // if let productData = viewModel.selectedProduct {
            ProductDetailsScreen(viewModel:ProductDetailsViewModel(product: viewModel.selectedProduct, productMoreUseCase: ProductMoreUseCase(productDetailRepository: ProductDetailRepositoryImplentation())
                ))
            //}
            }
        .bottomSheet(isPresented: $viewModel.showFilterList) {
            CategoriesBottomSheet(categories: UserSessionManager.shared.categories,completion: {category in
                viewModel.showFilterList = false
                self.categoryId = category.id
              //  viewModel.fetchPoductList(categoryId: self.categoryId)
            })
                .frame( height: UIScreen.screenHeight * 0.70)
        }
        .topBarView(titleView: appCoordinator.titleView(),
                    rightButtons: ViewUtils.shared.cartButtonView(count: appCoordinator.cartItemCount, action: {
            appCoordinator.navigateToCart = true
                      }))
        .alert(viewModel.alertMessage, isPresented: $viewModel.showAlert) {
            Button(TextResource.cancel) {
                viewModel.showAlert = false
            }
            Button(TextResource.update) {
                Task{
                    UserSessionManager.shared.productIdententiyArray = []
                  try await viewModel.updateProductCart(action: CartAction.add,
                                                productId: viewModel.selectedProductIdentiy?.productId ?? "",
                                                productVariantId: viewModel.selectedProductIdentiy?.variantId ?? "",
                                                forceAddToCart: true)
                    viewModel.showAlert = false
                }
            }
        }
    }
    
}

struct ActivityIndicator: UIViewRepresentable {
    
    @Binding var isAnimating: Bool
    var color: UIColor = UIColor.gray
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: UIViewRepresentableContext<ActivityIndicator>) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.color = color
        return indicator
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: UIViewRepresentableContext<ActivityIndicator>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
