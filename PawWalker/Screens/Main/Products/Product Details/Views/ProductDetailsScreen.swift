//
//  ProductDetailsScreen.swift
//  PawWalker
//
//  Created by shagar on 23/01/25.
//

import SwiftUI

struct ProductDetailsScreen: View {
    @StateObject var viewModel : ProductDetailsViewModel
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var appCoordinator: AppCoordinator
    //  var cancelCallBack : (String) -> ()
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0){
                    imageView
                        .padding(.top,10)
                    nameView
                    ratingView
                    variantsView
                    HStack {
                        priceView
                        Spacer()
                        moreOptionsView
                            .isRemove(viewModel.moreProductList.isEmpty)
                    }
                    productCartView
                        .padding(.top,30)
                        .padding(.horizontal,20)
                    discriptionView
                    reviewView
                        .padding(.top,20)
                    similarProductView
                        .padding(.top,20)
                        .padding(.bottom,30)
                    Spacer()
                }
            }
            .padding(.horizontal,15)
        }
        .toolbar(.hidden, for: .tabBar)
        .onAppear(perform: {
            viewModel.updateData()
        })
        .makeWithLoader(isLoading: $viewModel.isLoading)
        .topBarView(titleView: ViewUtils.shared.titleView(title: TextResource.productDetails),
                    leftButtons: ViewUtils.shared.backButtonView {
            self.mode.wrappedValue.dismiss()
            //cancelCallBack(categoryId)
        },rightButtons: ViewUtils.shared.cartButtonView(count: appCoordinator.cartItemCount, action: {
            viewModel.showCartPage = true
        }))
        .navigationDestination(isPresented: $viewModel.showReviewPage, destination: {
            ProductReviewScreen()
                .environmentObject(viewModel)
        })
        .navigationDestination(isPresented: $viewModel.showCartPage) {
            CartDeatilsScreen(browseCompletion: {}, payementCompletion: {})
        }
        .navigationDestination(isPresented: $viewModel.navigateToDetailScreen) {
            ProductDetailsScreen(viewModel:
                                    ProductDetailsViewModel(product: self.viewModel.product!,
                                    productMoreUseCase: ProductMoreUseCase(productDetailRepository: ProductDetailRepositoryImplentation()),
                                        productDetailUseCase: ProductDetailUseCase(repository: ProductDetailRepositoryImplentation())))
        }
        .customPopupAlertView(
            alertView: ProductReviewAlert(
                sumbitAction: {reviewText,rating in
                    self.viewModel.reviewText = reviewText
                    self.viewModel.reviewRating = rating
                    viewModel.submitReviewToServer()
                    self.viewModel.showReviewBottomSheet = false
                },
                closeAction: {
                    self.viewModel.showReviewBottomSheet = false
                }
            ),
            showAlert: $viewModel.showReviewBottomSheet
        )
        .task {
            await viewModel.loadData()
        }
        .bottomSheet(isPresented: $viewModel.showMoreView) {
            MoreProductListView(viewModel: viewModel)
                .frame( height: UIScreen.screenHeight * 0.60)
        }
        .alert(viewModel.alertMessage, isPresented: $viewModel.showAlertForCart) {
            Button(TextResource.cancel) {
                viewModel.showAlertForCart = false
            }
            Button(TextResource.update) {
                Task{
                    UserSessionManager.shared.productIdententiyArray = []
                   await viewModel.updateProductCart(action: CartAction.add,
                                                productId: viewModel.selectedProductIdentity?.productId ?? "",
                                                productVariantId: viewModel.selectedProductIdentity?.variantId ?? "",
                                                forceAddToCart: true)
                    viewModel.showAlertForCart = false
                }
            }
        }
    }
    
    private var moreOptionsView : some View {
        Button(action: {
            viewModel.showMoreView = true
        }, label: {
            Text(TextResource.moreOption)
                .foregroundStyle(.primaryButton)
                .font(FontConstants.primaryMediumTitle14)
        })
    }
    var sellerView : some View {
        HStack {
            Text("\(TextResource.seller):")
                .foregroundStyle(Color(ColorResource.priceGray))
                .font(FontConstants.primaryMediumTitle16)
            Text(viewModel.product?.addedBy ?? TextResource.empty)
                .font(FontConstants.primaryMediumTitle16)
                .foregroundStyle(.black)
            Spacer()
        }
    }
    private var imageView : some View {
        HStack{
            Spacer()
            ImageURLView(url: viewModel.selectedVariant?.productImage1 ?? TextResource.empty)
                .scaledToFit()
                .frame(height: 160,alignment: .center)
                .frame(width: UIScreen.screenWidth - 100)
                .itemBorderStyle(radius : 15,shadowRadius: 4,bottomShadow: 0)
            Spacer()
        }
    }
    private var nameView : some View {
        VStack {
            Text(viewModel.product?.productName ?? TextResource.empty)
                .font(FontConstants.primaryMediumTitle14)
                .padding(.top,20)
        }
    }
    
    var variantsView : some View {
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack {
                ForEach(viewModel.getVariantList(),id: \.productVariantID) {variant in
                    Button(action: {
                        viewModel.selectedVariant = variant
                    }, label: {
                        VariantWeightView(variant: variant,isSelected: (viewModel.selectedVariant?.productVariantID == variant.productVariantID),isLarge: true)
                    })
                }
            }
        }
        .frame(height : 80)
    }
    
    private var priceView : some View {
        HStack(spacing: 5) {
            Text(TextResource.mrp)
                .foregroundStyle(Color(ColorResource.priceGray))
                .font(FontConstants.primaryMediumTitle16)
            if viewModel.getNonDiscountPrice() != 0 {
                Text("₹\(viewModel.getNonDiscountPrice())")
                    .strikethrough()
                    .foregroundStyle(Color(ColorResource.priceGray))
                    .font(FontConstants.primaryMediumTitle16)
            }
            Text("₹\(viewModel.getDiscountPrice())")
                .font(FontConstants.primaryMediumTitle16)
                .foregroundStyle(Color.black)
            Text("\(viewModel.selectedVariant?.dispalyDiscountPercentage ?? 0)% Off")
                .font(FontConstants.primaryMediumTitle16)
                .foregroundStyle(Color.green)
            
            Spacer()
        }
        .padding(.top,10)
    }
    
    private var addToCartButton : some View {
        Button {
            Task{
                await viewModel.updateProductCart(action: .add,
                                                  productId: self.viewModel.product?.productID ?? "",
                                                  productVariantId: self.viewModel.selectedVariant?.productVariantID ?? "",
                                                  forceAddToCart: false)
            }
        } label: {
            Text(TextResource.addToCart)
                .primaryButtonStyle(height: 48,font: FontConstants.primaryMediumTitle16,fullWidth: true,cornerRadius: 12)
        }
        
    }
    
    private var quantityView : some View {
        QuantityView(quantity: viewModel.selectedVariant?.cartQuantity ?? 0,
                     buttonPressAction: { action in
            Task {
                await viewModel.updateProductCart(action: action,
                                                  productId: viewModel.product?.productID ?? "",
                                                  productVariantId: viewModel.selectedVariant?.productVariantID ?? "",
                                                  forceAddToCart: false)
            }
        }, isFullScreen: true)
    }
    @ViewBuilder
    private var productCartView : some View {
        if viewModel.selectedVariant?.isInCart == true {
            quantityView
        }
        else {
            addToCartButton
        }
    }
    
    private var discriptionView: some View {
        VStack(alignment: .leading,spacing: 0) {
            Button(action: {
                viewModel.showMore.toggle()
            }, label: {
                HStack{
                    Text(TextResource.productDescription)
                        .font(FontConstants.primaryMediumTitle14)
                        .foregroundStyle(Color.black)
                    Spacer()
                    Image(viewModel.showMore ? ImageResource.upArrowIcon : ImageResource.downArrowIcon)
                        .resizable()
                        .frame(width:20,height: 20)
                }
            })
            
            if viewModel.showMore {
                discriptionDetailView
            }
            else {
                discriptionShortView
            }
        }
        .makeBackgroundView()
        .padding(.top,20)
    }
    
    private var discriptionShortView: some View {
        VStack(alignment: .leading,spacing: 5) {
            Text(viewModel.product?.productDescription ?? TextResource.empty)
                .lineLimit(5)
                .font(FontConstants.primaryRegularTitle12)
                .padding(.top,10)
        }
    }
    private var discriptionDetailView: some View {
        VStack(alignment: .leading,spacing: 5) {
            Text(viewModel.product?.productDescription ?? TextResource.empty)
                .font(FontConstants.primaryRegularTitle12)
                .padding(.top,10)
        }
    }
    
}
