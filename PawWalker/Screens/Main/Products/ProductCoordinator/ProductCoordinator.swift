////
////  ProductCoordinator.swift
////  PawWalker
////
////  Created by shagar on 21/07/26.
////
//
//
//import SwiftUI
//
//enum ProductPages : Hashable {
//    case productListing(categoryId : Binding<String>)
//    case productDetail(product : Product?)
//}
//
//class ProductCoordinator : ObservableObject {
//    @Published var path = NavigationPath()
//    weak var appCoordinator: AppCoordinator?
//    func push(_ page: ProductPages) {
//        path.append(page)
//    }
//    func pop() {
//        path.removeLast()
//    }
//    func popToRoot() {
//        path = NavigationPath()
//    }
//    
//    @ViewBuilder
//    func build(page : ProductPages) -> some View {
//        switch page {
//        case .productListing(let categoryId):
//            makeProductListPage(categoryId: categoryId)
//        case .productDetail(let product):
//            makeProductDetailPage(product: product)
//        }
//    }
//    func makeProductListPage(categoryId : Binding<String>) -> ProductListScreen {
//        return ProductListScreen(coordinator: self, categoryId: categoryId)
//    }
//    func makeProductDetailPage(product : Product?) -> ProductDetailsScreen {
//        let viewModel = ProductDetailsViewModel(product: product)
//        return ProductDetailsScreen(viewModel: viewModel)
//    }
//    
//}
