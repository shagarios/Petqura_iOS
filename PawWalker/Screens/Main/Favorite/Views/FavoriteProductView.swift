//
//  FavoriteProductView.swift
//  PawWalker
//
//  Created by shagar on 06/04/25.
//

import SwiftUI

struct FavoriteProductView: View {
    var product : FavoriteProduct
    var deleteProductCallBack: (FavoriteProduct) -> ()
    var cartCallBack: (FavoriteProduct) -> ()
    var body: some View {
        HStack(spacing: 20){
            imageView
            detailsView
        }
        .padding(.bottom,10)
    }
    
    var imageView : some View {
        ImageURLView(url: product.variants?.productImage1 ?? "")
                .frame(width : 90, height: 90)
                .itemBorderStyle(radius : 20)
    }
    var detailsView : some View {
        VStack{
            HStack{
                Text(product.productName ?? TextResource.empty)
                    .lineLimit(1)
                    .font(FontConstants.primaryMediumTitle12)
                Spacer()
                favoriteView
            }
            HStack{
                Text(product.brandName ?? TextResource.empty)
                    .font(FontConstants.primaryRegularTitle11)
                    .lineLimit(1)
                Spacer()
                if getNonDiscountPrice() != 0 {
                    Text("₹\(getNonDiscountPrice())")
                        .strikethrough()
                        .foregroundStyle(Color(ColorResource.priceGray))
                        .font(FontConstants.primaryRegularTitle11)
                }
                Text("₹\(getDiscountPrice())")
                    .font(FontConstants.primaryMediumTitle12)
                    .foregroundStyle(Color.black)
                Text("\(product.variants?.dispalyDiscountPercentage ?? 0)% Off")
                    .font(FontConstants.primaryRegularTitle11)
                    .foregroundStyle(Color.black)
            }
            HStack {
                Text(product.variants?.variantName ?? "")
                    .foregroundStyle(.black)
                    .font(FontConstants.primaryRegularTitle11)
                    .makeBackgroundView(color : Color(ColorResource.littleGray),
                                        horizontalPadding: 10,verticalPadding: 5,radius: 5)
                Spacer()
                Button(action: {
                    cartCallBack(product)
                }, label: {
                    Text(TextResource.addToCart)
                        .foregroundStyle(.white)
                        .font(FontConstants.primaryRegularTitle11)
                        .makeBackgroundView(color : Color(ColorResource.primaryButton),
                                            horizontalPadding: 10,verticalPadding: 5,radius: 5)
                })
               
            }
        }
    }
    
    private var favoriteView : some View {
        Button(action: {
            deleteProductCallBack(product)
        }, label: {
            ZStack {
                Circle()
                    .foregroundStyle(Color(ColorResource.favoriteWhite))
                    .frame(width: 36,height: 36)
                Image(.favoriteFilledIcon)
            }
        })
       
    }
    func getNonDiscountPrice() -> Int {
        return Int(product.variants?.nonDiscountPrice ?? 0)
    }
    func getDiscountPrice() -> Int {
        return Int(product.variants?.discountedPrice ?? 0)
    }
}
