//
//  ProductIte.swift
//  PawWalker
//
//  Created by shagar on 06/05/25.
//
import SwiftUI
import Combine

struct ProductItemView : View {
    var product : Product
    @State var selectedVaiant : Variant?
    var productDetailCallBack: (Product) -> () = {_ in }
    var cartCallback: () -> () = {}
    var favoriteCallBack: (FavoriteActions,String,String) -> ()
    var addToCartCallBack : (String,String,CartAction) -> ()
    var isSimilarProduct : Bool
    
    var body: some View {
        VStack(spacing: 0) {
            imageView
                nameView
                .padding(.top,10)
            variantsView
                .padding(.top,5)
           
            priceView
                .padding(.top,5)
           cartQuantityButton
                .padding(.top,5)
                
        }
        .overlay(alignment: .topTrailing, content: {
            favoriteView
            .padding(.top,5)
            .padding(.trailing,5)
            
        })
        .onAppear {
            if selectedVaiant == nil {
                self.selectedVaiant = self.product.variants.first
                let variant = UserSessionManager.shared.productIdententiyArray.first(where: {$0.variantId == selectedVaiant?.productVariantID})
                if variant?.variantId == selectedVaiant?.productVariantID {
                    selectedVaiant?.isInCart = variant?.isInCart
                    selectedVaiant?.cartQuantity = variant?.cartQuantity
                }
                else {
                    selectedVaiant?.isInCart = false
                    selectedVaiant?.cartQuantity  = 0
                }
            }
        }
        .onChange(of: UserSessionManager.shared.productIdententiyArray) { productList in
            let variant = productList.first(where: {$0.variantId == selectedVaiant?.productVariantID})
            if variant?.variantId == selectedVaiant?.productVariantID {
                selectedVaiant?.isInCart = variant?.isInCart
                selectedVaiant?.cartQuantity = variant?.cartQuantity
            }
            else {
                selectedVaiant?.isInCart = false
                selectedVaiant?.cartQuantity  = 0
            }
        }
       
    }
    var sellerView : some View {
        HStack {
            Text("\(TextResource.seller):")
                .foregroundStyle(Color(ColorResource.priceGray))
                .font(FontConstants.primaryMediumTitle12)
            Text(product.addedBy ?? TextResource.empty)
                .font(FontConstants.primaryMediumTitle12)
                .foregroundStyle(.black)
            Spacer()
        }
    }
    var imageView : some View {
        VStack{
            ImageURLView(url: getProductImage(product: product))
                .frame(width : 130, height: 130)
                .itemBorderStyle(radius : 20)
        }
        .onTapGestureForced {
            productDetailCallBack(product)
        }
    }
    func getProductImage(product : Product) ->  String {
        let images = product.variants.first
        let productImage = images?.productImage1 ??  ""
        return productImage
    }
    var nameView : some View {
        Text(product.productName ?? TextResource.empty)
            .font(FontConstants.primaryMediumTitle12)
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(width: 150, alignment: .leading)
    }
    var variantsView : some View {
        ScrollView(.horizontal,showsIndicators: false) {
            LazyHStack {
                ForEach(product.variants,id: \.productVariantID) {variant in
                    Button(action: {
                        self.selectedVaiant = variant
                    }, label: {
                        VariantWeightView(variant: variant,isSelected:
                            (selectedVaiant?.productVariantID == variant.productVariantID))
                    })
                }
            }
        }
    }
    private var priceView : some View {
        HStack(spacing: 3) {
            if getNonDiscountPrice() != 0 {
                Text("₹\(getNonDiscountPrice())")
                    .strikethrough()
                    .foregroundStyle(Color(ColorResource.priceGray))
                    .font(FontConstants.primaryRegularTitle11)
            }
            Text("₹\(getDiscountPrice())")
                .font(FontConstants.primaryMediumTitle12)
                .foregroundStyle(Color.black)
            Text("\(selectedVaiant?.dispalyDiscountPercentage ?? 0)% Off")
                .font(FontConstants.primaryRegularTitle11)
                .foregroundStyle(Color.green)
                
            Spacer()
        }
    }
    private var favoriteView : some View {
        ZStack {
            Circle()
                .foregroundStyle(Color(ColorResource.favoriteWhite))
                .frame(width: 36,height: 36)
            Image((selectedVaiant?.isFavorite ?? false) ? .favoriteFilledIcon : .favoriteIcon)
        }
        .onTapGesture {
            if selectedVaiant?.isFavorite  == false {
                selectedVaiant?.isFavorite = true
                favoriteCallBack(.addFavorite,product.productID,selectedVaiant?.productVariantID ?? "")
            }
            else {
                selectedVaiant?.isFavorite = false
                favoriteCallBack(.deleteFavorite,product.productID,selectedVaiant?.productVariantID ?? "")
            }
        }
    }
    func getNonDiscountPrice() -> Int {
        return Int(selectedVaiant?.nonDiscountPrice ?? 0)
    }
    func getDiscountPrice() -> Int {
        return Int(selectedVaiant?.discountedPrice ?? 0)
    }
    @ViewBuilder
    private var addToCartButton : some View {
        Button {
            addToCartCallBack(product.productID,self.selectedVaiant?.productVariantID ?? TextResource.empty, .add)
            
        } label: {
                Text(TextResource.addToCart)
                    .primaryButtonStyle(height: 33,font: FontConstants.primaryMediumTitle12,fullWidth: true,cornerRadius: 15)
           
        }
    }
    @ViewBuilder
    private var cartQuantityButton : some View {
        if selectedVaiant?.isInCart == true {
            QuantityView(quantity: selectedVaiant?.cartQuantity ?? 0, buttonPressAction: {action in
                addToCartCallBack(product.productID,self.selectedVaiant?.productVariantID ?? TextResource.empty, action)
            })
        }
        else {
            addToCartButton
        }
    }
   
    
}

struct VariantWeightView : View {
    let variant : Variant
    var isSelected : Bool
    var isLarge : Bool = false
    var body : some View {
        VStack(spacing : 0){
            variateNameView
        }
    }
    private var variateNameView : some View {
        Text(variant.variantName ?? TextResource.empty)
            .foregroundStyle(isSelected ? Color.white : Color.black)
            .font(isLarge ?  FontConstants.primaryMediumTitle14: FontConstants.primaryRegularTitle11 )
            .padding(.vertical,isLarge ? 9 : 5)
            .padding(.horizontal,isLarge ? 20 : 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .foregroundStyle(isSelected ? Color(ColorResource.primaryButton) : Color(ColorResource.littleGray))
            )
    }
}


enum FavoriteActions : String {
    case addFavorite
    case deleteFavorite
}

struct QuantityView :  View {
    var quantity : Int
    var buttonPressAction : (CartAction) -> ()
    var body : some View {
        HStack() {
            Button(action: {
                buttonPressAction(.less)
            }, label: {
                Image(ImageResource.minusIcon)
            })
            Text(quantity.stringValue())
                .font(FontConstants.primaryMediumTitle11)
                .makeBackgroundView(color: ColorContants.inAciveGray,horizontalPadding: 10,
                                    verticalPadding: 2,radius: 5)
                .padding(.leading,15)
            Button(action: {
                buttonPressAction(.add)
            }, label: {
                Image(ImageResource.plusIcon)
            })
            .padding(.leading,15)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(style: StrokeStyle(lineWidth: 1))
                .foregroundStyle(Color.primaryButton)
                .frame(height: 30)
        )
    }
}
