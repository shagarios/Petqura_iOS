//
//  CartScreen.swift
//  PawWalker
//
//  Created by shagar on 10/02/25.
//

import SwiftUI

struct CartDeatilsScreen: View {
    @StateObject var viewModel = CartDetailsViewModel()
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    var browseCompletion : () -> ()
    var payementCompletion : () -> ()
    var body: some View {
        VStack(spacing : 0) {
            if viewModel.cartList.isEmpty {
                cartEmptyView
            } else {
                VStack(spacing: 0){
                    ScrollView(showsIndicators: false) {
                        cartDataView
                    }
                    addressWithPayButtonView
                        .padding(.top,8)
                        .padding(.bottom,30)
                }
            }
            Spacer()
        }
        .topBarView(titleView: ViewUtils.shared.titleView(title: TextResource.cart),
                    leftButtons: ViewUtils.shared.backButtonView {
            mode.wrappedValue.dismiss()
        },rightButtons: ViewUtils.shared.cartButtonView(count: viewModel.cartCount, action: {
            
        }))
        .task {
            await viewModel.fetchCart()
            viewModel.fetchSimilarProducts()
            viewModel.getAddressList()
        }
        .onTapGestureForced {
            UIApplication.shared.endEditing()
        }
        .sheet(isPresented: $viewModel.showCashfreePage) {
            CashFreeHandler(paymentSessionId: viewModel.sessionID, orderId: viewModel.orderID)
        }
        .onChange(of: viewModel.navigateToMyorders) { newValue in
            if newValue {
                payementCompletion()
            }
        }
        .navigationDestination(isPresented: $viewModel.navigateToProductDetail,
                               destination: {
            if let productData = viewModel.selectedProduct {
                ProductDetailsScreen(viewModel:ProductDetailsViewModel(
                    product: productData,
                productMoreUseCase: ProductMoreUseCase(productDetailRepository:
                                                        ProductDetailRepositoryImplentation()),
                productDetailUseCase: ProductDetailUseCase(repository: ProductDetailRepositoryImplentation())))
            }
        })
        
    }
    private var cartDataView : some View {
            VStack(spacing : 0) {
                VStack {
                    cartListView
                    Divider()
                    deliveryTipView
                    similarProductView
                        .padding(.top,10)
                    billDetailsView
                        .padding(.vertical,20)
                }
                .padding(.horizontal,10)
            }
    }
    private var cartEmptyView : some View {
        VStack {
            Image(ImageResource.cartEmpty)
                .padding(.top,30)
            Text(TextResource.cartEmpty)
                .font(FontConstants.primaryMediumTitle16)
                .padding(.top,20)
            Button(action: {
                browseCompletion()
            }, label: {
                Text(TextResource.browseProduct)
                    .primaryButtonStyle(fullWidth : true)
                    .padding(.horizontal,40)
            })
            .padding(.top,30)
        }
    }
    
    private var addressView : some View {
        HStack {
            Text(TextResource.deliveryAddress)
                .font(FontConstants.primaryMediumTitle14)
                .foregroundStyle(Color(ColorResource.darkGray))
            Image(ImageResource.trashBinIcon)
            Spacer()
            Button(action: {
                viewModel.navigateToAddressList = true
            }, label: {
                Text(TextResource.addToCart)
            })
        }
    }
    
    private var cartListView : some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.cartList,id: \.cartID) { cart in
                    CartItemView(cart: cart, buttonPressAction: {action in
                        buttonActions(action: action, cartId: cart.cartID)
                    })
                        .padding(.vertical,10)
                }
            }
        }
    }
    
    func buttonActions(action : CartAction,cartId : String) {
        switch action {
        case .add:
            viewModel.updateCartItem(action: .add, cartId: cartId)
        case .less:
            viewModel.updateCartItem(action: .less, cartId: cartId)
        }
    }
    
}


struct CartItemView : View {
    var cart : CartElement
    var buttonPressAction : (CartAction) -> ()
    var body: some View {
        HStack {
            productImage
            detailsView
                .padding(.leading,15)
        }
    }
    
    private var productImage : some View {
        ImageURLView(url: cart.productVariant?.productImage1 ?? TextResource.empty)
            .frame(width : 80, height: 90)
            .itemBorderStyle(radius: 20,shadowRadius : 3,bottomShadow: 0)
            .padding(.leading,10)
    }
    private var detailsView : some View {
        VStack(alignment: .leading) {
            titleView
        variantQuantityView
        }
    }
    private var titleView : some View {
        HStack{
            Text(cart.productVariant?.productName ?? TextResource.empty)
                .font(FontConstants.primaryMediumTitle12)
                .lineLimit(2)
            Spacer()
            priceView
        }
    }
    
    private var variantQuantityView : some View {
        HStack {
            Text(cart.productVariant?.variantName ?? TextResource.empty)
                .foregroundStyle(Color.white)
                .font(FontConstants.primaryRegularTitle11)
                .makeBackgroundView(color: Color(ColorResource.primaryButton),
                                    horizontalPadding: 10,verticalPadding: 2,radius: 5)
            quantityView
            
        }
    }
    
    private var quantityView : some View {
        HStack {
            Button(action: {
                buttonPressAction(.less)
            }, label: {
                Image(ImageResource.minusIcon)
            })
            Text(String(cart.quantity ?? 0))
                .font(FontConstants.primaryMediumTitle11)
                .makeBackgroundView(color: ColorContants.inAciveGray,horizontalPadding: 10,
                                    verticalPadding: 2,radius: 5)
            Button(action: {
                buttonPressAction(.add)
            }, label: {
                Image(ImageResource.plusIcon)
            })
        }
    }
    
    private var deleteButton : some View {
        Button(action: {}, label: {
            Image(ImageResource.trashBinIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
        })
    }
    
    private var priceView : some View {
        VStack(alignment: .leading) {
            Text(" \(TextResource.rupeesSymbol)" + price())
                .strikethrough()
                .font(FontConstants.primaryRegularTitle12)
                .foregroundStyle(Color.darkGray)
            Text(" \(TextResource.rupeesSymbol)" + (cart.totalPrice ?? 0).stringValue())
                .font(FontConstants.primaryMediumTitle12)
        }
    }
    
    func price() -> String {
        let price = cart.productVariant?.price ?? 0
        let quantity = Double(cart.quantity ?? 0)
        let totalPrice = price * quantity
        return totalPrice.stringValue()
    }
}
