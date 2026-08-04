//
//  CartScreen+Views.swift
//  PawWalker
//
//  Created by shagar on 13/02/25.
//
import SwiftUI

extension CartDeatilsScreen {
    var billDetailsView : some View {
        VStack(alignment: .leading) {
            VStack(spacing : 15){
                Button(action: {
                    self.viewModel.showFullBill.toggle()
                }, label: {
                    HStack {
                        Text(TextResource.billDetails)
                            .font(FontConstants.primaryMediumTitle14)
                            .foregroundStyle(Color.black)
                        Spacer()
                            Image(viewModel.showFullBill ? ImageResource.upArrowIcon : ImageResource.downArrowIcon)
                                .resizable()
                                .frame(width:20,height: 20)
                    }
                })
                
                BillItemView(name: TextResource.price, value: (viewModel.cartDetails?.netAmount ?? 0).stringValue())
                    .isRemove(!viewModel.showFullBill)
        
                BillItemView(name: TextResource.gst, value: (viewModel.cartDetails?.gst ?? 0).stringValue())
                    .isRemove(!viewModel.showFullBill)
            
                BillItemView(name: TextResource.deliveryCharge, value: (viewModel.cartDetails?.shippingCharge ?? 0).stringValue())
                    .isRemove(!viewModel.showFullBill)
                
                BillItemView(name: "Tip", value: viewModel.deliveryTipValue.stringValue())
                    .isRemove(!viewModel.showFullBill)
                BillItemView(name: "Usable Coins", value: (viewModel.cartDetails?.pointsAvailable ?? 0).stringValue())
                    .isRemove(!viewModel.showFullBill)
                useCoinView
                    .padding(.top,-10)
                    .padding(.leading,5)
                    .isRemove(!viewModel.showFullBill)
                Divider()
                BillItemView(name: "Payable Amount", value: viewModel.totalPrice())
                    .padding(.top,5)
            }
            .makeBackgroundView()
        }
        
    }
  
    var useCoinView : some View {
        HStack{
            Image(viewModel.isUseCoins ? .checkBoxSelected : .checkBox)
                .resizable()
                .frame(width: 15,height: 15)
            Text("Use Coins")
                .font(FontConstants.primaryRegularTitle12)
                .foregroundStyle(ColorContants.billItemNameGray)
            Spacer()
        }
        .onTapGestureForced {
            viewModel.isUseCoins.toggle()
        }
    }
    
    var addressWithPayButtonView : some View {
        VStack(alignment: .leading) {
            addressView
            payButton
                .padding(.bottom,30)
                .padding(.top,5)
        }
        .background(
            ColorContants.lightLittleGray
        )
    }
    
    private var addressView : some View {
        HStack {
            VStack(alignment: .leading,spacing: 0) {
                Text(viewModel.myAddress?.fullname ?? TextResource.empty)
                    .font(FontConstants.primaryMediumTitle12)
                    .padding(.top,15)
                    .foregroundStyle(ColorContants.dateGray)
                Text(viewModel.myAddress?.address ?? TextResource.empty)
                    .font(FontConstants.primaryRegularTitle11)
                    .foregroundStyle(ColorContants.billItemNameGray)
                    .padding(.top, 5)
            }
            .isRemove(viewModel.addressList.isEmpty)
            Spacer()
            addressChangeButton
        }
        .padding(.horizontal,20)
    }
    private var addressChangeButton : some View {
        Button(action: {
            viewModel.navigateToAddressList = true
        }, label: {
            Text(viewModel.addressList.isEmpty ? TextResource.addNewAddress : TextResource.change)
                .font(FontConstants.primaryMediumTitle12)
                .foregroundStyle(Color(ColorResource.primaryButton))
                .padding(.top, viewModel.addressList.isEmpty ? 10 : 0)
        })
    }
    private var payButton : some View {
        MTSlideToOpen(
            thumbnailTopBottomPadding : 5,
            thumbnailLeadingTrailingPadding: 6,
            text : TextResource.slideToPay,
            textColor: Color.white,
            iconName: ImageName.slideArrowIcon,
            didReachEndAction: { view  in
                if viewModel.addressList.isNotEmpty {
                    viewModel.productPayment()
                }
                else {
                    ToastCenter.shared.showToast(TextResource.deliveryAddressValidationText,type: .success)
                }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        view.resetState()
                    }
                
            }
        )
        .frame(height : 40)
            .padding(.horizontal,30)
    }
    var deliveryTipView : some View {
        VStack {
            HStack{
                VStack(alignment : .leading) {
                    Text(TextResource.tipDescription)
                        .font(FontConstants.primaryMediumTitle12)
                    HStack{
                        ForEach(viewModel.deliveryTipList,id: \.rawValue) {item in
                            Button(action: {
                                viewModel.deliveryTip = item
                                if item == DeliveryTip.other {
                                    viewModel.showDeliveryTipOtherView = true
                                }
                            }, label: {
                                Text(item.displayValue)
                                    .font(FontConstants.primaryRegularTitle12)
                                    .applyOutline(verticalPadding : 8, hortizontalPadding: 12,
                                                  cornerRadius: 5,
                                                  outlineColor: viewModel.deliveryTipColor(item: item))
                                
                            })
                           
                        }
                        otherView
                            .onTapGestureForced {
                                viewModel.deliveryTip = .other
                                viewModel.showDeliveryTipOtherView = true
                            }
                            .isRemove(viewModel.showDeliveryTipOtherView)
                        deliveryTipOtherView
                            .isRemove(!viewModel.showDeliveryTipOtherView)
                        Image(ImageResource.deliveryPatnerIcon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40,height: 40)
                            .padding(.leading,10)
                        Spacer()
                    }
                }
                
            }
        }
        .padding(.horizontal,20)
    }
    var otherView : some View {
        Text(DeliveryTip.other.rawValue)
            .font(FontConstants.primaryRegularTitle12)
            .applyOutline(verticalPadding : 8, hortizontalPadding: 12,
                          cornerRadius: 5,
                          outlineColor: viewModel.deliveryTipColor(item: .other))
    }
    var deliveryTipOtherView : some View {
        HStack(spacing: 0) {
            Text(TextResource.rupeesSymbol)
            VStack(spacing : 0){
                TextField(TextResource.empty, text: $viewModel.tipValue)
                    .keyboardType(.numberPad)
                    .onChange(of: viewModel.tipValue) { newValue in
                        viewModel.deliveryTipValue = Double(newValue) ?? 0
                    }
                Divider()
            }
            .padding(.leading,2)
            Image(ImageResource.close)
                .resizable()
                .frame(width : 20,height: 20)
                .padding(.leading,5)
                .onTapGestureForced {
                    viewModel.showDeliveryTipOtherView = false
                    viewModel.deliveryTip = .tip0
                }
        }
        .font(FontConstants.primaryRegularTitle12)
        .applyOutline(verticalPadding : 6, hortizontalPadding: 10,
                      cornerRadius: 5,
                      outlineColor:  Color(ColorResource.primaryButton))
    }
    var similarProductView : some View {
        VStack(alignment: .leading) {
            similarProductTitleView
            similarProductListView
        }
       
     }
     
   var similarProductTitleView : some View {
       Text(TextResource.productForYou)
             .font(FontConstants.primaryMediumTitle16)
             .foregroundStyle(.black)
     }
     var similarProductListView : some View {
         ScrollView(.horizontal,showsIndicators: false) {
             LazyHStack {
                 ForEach(viewModel.productList,id: \.productID) {product in
                     ProductItemView(product: product,
                                     productDetailCallBack: {product in
                         self.viewModel.selectedProduct = product
                         self.viewModel.selectedVariant = product.variants.first
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
                         Task {
                             await viewModel.postToCart(
                                productId: productId,
                                varaintId: variantId,
                                quantity: 1
                             )
                             viewModel.fetchCartList()
                         }
                        
                     }, isSimilarProduct: true)
                     .frame(width: 150)
                     .padding(.leading,10)
                 }
             }
         }
     }

}


struct BillItemView : View {
    let name : String
    let value : String
    let nameColor : Color = ColorContants.billItemNameGray
    let valueColor : Color = ColorContants.dateGray
    var body: some View {
        HStack {
            Text("\(name) :")
                .font(FontConstants.primaryRegularTitle12)
                .foregroundStyle(nameColor)
            Spacer()
            Text(value)
                .font(FontConstants.primaryMediumTitle12)
                .foregroundStyle(valueColor)
        }
    }
}
