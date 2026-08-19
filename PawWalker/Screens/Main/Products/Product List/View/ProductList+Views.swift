//
//  ProductList+Views.swift
//  PawWalker
//
//  Created by shagar on 30/05/25.
//
import SwiftUI

extension ProductListScreen {
     var searchView : some View {
        TextField(TextResource.productSearchPlaceHolder, text: $viewModel.searchText)
    }
    
     var topView : some View {
        HStack {
            searchView
            filterView
        }
        .makeSearchView()
    }
    var filterView : some View {
        Button(action: {
            viewModel.showFilterList.toggle()
        }, label: {
            Image(ImageResource.filterIcon)
                .resizable()
                .frame(width: 25,height: 25)
                .foregroundStyle(.darkGray)
                
        })
    }
    
   var productListView : some View {
       ScrollView(showsIndicators: false) {
           LazyVGrid(columns: colomns,spacing: 20) {
               ForEach(viewModel.searchText.isEmpty ?
                       viewModel.productList : viewModel.filteredProductList,id: \.productID) { product in
                   ProductItemView(product: product,
                                   productDetailCallBack: {product in
                       self.viewModel.selectedProduct = product
                       self.viewModel.navigateToProductDetail = true
                   }, cartCallback: {},favoriteCallBack: { action, productId, variantId in
                       if action == FavoriteActions.addFavorite {
                           viewModel.addToFavorite(productId: productId,
                                                   variantId: variantId) { status in
                           }
                       }
                       else {
                           viewModel.deleteProductFromFavorites(productId: productId,
                                                                variantId: variantId) { status in
                           }
                       }
                   },addToCartCallBack: { productId, variantId,action  in
                       Task{
                           try await viewModel.updateProductCart(action: action,
                                                                 productId: productId,
                                                                 productVariantId: variantId,
                                                                 forceAddToCart: false)
                           
                       }
                   },isSimilarProduct: false)
                   .onAppear{
                       if viewModel.searchText.isEmpty {
                           if viewModel.productList.last?.productID == product.productID {
                               if viewModel.hasNext {
                                   viewModel.page += 1
                                   viewModel.fetchPoductList(categoryId: self.categoryId)
                               }
                           }
                       }
                       else {
                           if viewModel.filteredProductList.last?.productID == product.productID {
                               if viewModel.searchHasNext {
                                   viewModel.searchPage += 1
                                   viewModel.searchProductList()
                               }
                           }
                       }
                   }
               }
           }
       }
        .safeAreaInset(edge: .bottom) {
            Color.clear
                .frame(height: 70)
        }
    }
    var emptyProductView : some View {
        VStack{
            Spacer()
            Image(ImageResource.noProducts)
                .resizable()
                .frame(width: 200,height: 200)
                .padding(.top,-30)
            Text(TextResource.noProductsInCategory)
                .font(FontConstants.primaryRegularTitle14)
                .multilineTextAlignment(.center)
               
            Button(action: {
                self.categoryId = ""
            }, label: {
                Text(TextResource.browseProduct)
                    .font(FontConstants.primaryRegularTitle16)
                    .primaryButtonStyle(fullWidth : true)
            })
            .padding(.top,20)
            Spacer()
        }
        .padding(.horizontal,30)
    }
    var emptyProductViewForSearch : some View {
        VStack{
            Spacer()
            Image(ImageResource.noProducts)
                .resizable()
                .frame(width: 200,height: 200)
                .padding(.top,-30)
            Text(TextResource.noProductsInCategory)
                .font(FontConstants.primaryRegularTitle14)
                .multilineTextAlignment(.center)
               
            Spacer()
        }
        .padding(.horizontal,30)
    }
}
