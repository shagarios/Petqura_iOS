//
//  MoreProductListView.swift
//  PawWalker
//
//  Created by shagar on 01/08/26.
//

import SwiftUI

struct MoreProductListView: View {
    @ObservedObject var viewModel : ProductDetailsViewModel
    var body: some View {
        VStack{
            headerView
            Divider()
            colomnView
            listView
        }
        .overlay(
            Image(ImageResource.closeGrayIcon)
                .padding(.top,10)
                .padding(.trailing,10)
                .onTapGesture {
                    viewModel.showMoreView = false
                }
            ,alignment: .topTrailing
        )
    }
    
    private var headerView : some View {
        Text(TextResource.otherSellers)
            .padding(.top,20)
            .font(FontConstants.primaryMediumTitle16)
    }
    private var colomnView : some View {
        HStack{
            productName(name: TextResource.seller)
                .frame(width: 120,alignment: .leading)
            Spacer()
            productName(name: TextResource.distance)
                .frame(width: 120,alignment: .leading)
            Spacer()
            productName(name: TextResource.price)
            
        }
    }
    
    func productName(name: String) -> some View {
        HStack {
            Text(name)
                .font(FontConstants.primaryMediumTitle12)
        }
    }
    private var listView : some View {
        ScrollView{
            LazyVStack{
                ForEach(viewModel.moreProductList,id: \.variantID) {product in
                    MoreProductView(product: product)
                        .onTapGestureForced {
                            viewModel.selectedMoreProduct = product
                            viewModel.showMoreView = false
                            Task {
                                await viewModel.fetchProductDetails(productId: product.productId ?? "")
                            }
                        }
                }
            }
        }
    }
}

struct MoreProductView : View {
    var product : MoreProduct
    var body: some View {
        HStack(spacing: 0){
            Text(product.productStore ?? "")
                .frame(width: 120,alignment: .leading)
            Spacer()
            Text(product.distanceKM ?? "")
                .frame(width: 120,alignment: .leading)
            Spacer()
            Text("₹\(product.price ?? 0)")
        }
        .font(FontConstants.primaryRegularTitle12)
    }
}
