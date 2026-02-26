//
//  ProductDetail+SimilarProduct.swift
//  PawWalker
//
//  Created by shagar on 10/05/25.
//
import SwiftUI

extension ProductDetailsScreen {
    
   var similarProductView : some View {
       VStack(alignment: .leading) {
           similarProductTitleView
           similarProductListView
           
       }
    }
    var similarProductTitleView : some View {
        Text(TextResource.similarProducts)
            .font(FontConstants.primaryMediumTitle16)
            .foregroundStyle(.black)
    }
    var similarProductListView : some View {
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack {
                ForEach(viewModel.productList,id: \.productID) {product in
                    ProductItemView(product: product,productDetailCallBack: {product in
                        self.viewModel.product = product
                        self.viewModel.navigateToDetailScreen = true
                        
                    },favoriteCallBack: { action, productId, variantId in
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
                    },addToCartCallBack: { productId, variantId in
                        Task {
                            await   viewModel.postToCart(
                                productId: productId,
                                varaintId: variantId,
                                quantity: 1
                            )
                        }
                    }, isSimilarProduct: true)
                    
                   .frame(width: 150)
                    .padding(.leading,10)
                }
            }
        }
    }
    
}
