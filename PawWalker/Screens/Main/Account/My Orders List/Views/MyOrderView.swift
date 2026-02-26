//
//  MyOrderView.swift
//  PawWalker
//
//  Created by shagar on 23/03/25.
//

import SwiftUI

struct MyOrderView: View {
    var myOrder : MyOrder
    var body: some View {
        HStack(spacing : 20) {
            imageView
            detailsView
            Spacer()
        }
        .padding(.bottom,10)
    }
    var imageView : some View {
            ImageURLView(url: myOrder.productImage)
                .frame(width : 90, height: 90)
                .itemBorderStyle(radius : 20)
    }
    var detailsView : some View {
        VStack(alignment: .leading) {
            productName
            quantityView
            sellerName
            placedView
        }
    }

    var productName : some View {
        Text(myOrder.productName)
            .font(FontConstants.primaryMediumTitle12)
            .lineLimit(1)
    }
    var sellerName: some View {
        Text("Seller Name: \(myOrder.sellerName)")
            .font(FontConstants.primaryRegularTitle11)
    }
    var quantityView : some View {
        HStack{
            Text(myOrder.variantName)
                .font(FontConstants.primaryRegularTitle11)
                .foregroundStyle(Color.white)
                .makeBackgroundView(color: Color(ColorResource.primaryButton),horizontalPadding: 10,verticalPadding: 3,radius: 5)
               Text("Qty")
                .font(FontConstants.primaryRegularTitle11)
                .padding(.leading,20)
            Text(String(myOrder.quantity))
                .font(FontConstants.primaryRegularTitle11)
                .makeBackgroundView(horizontalPadding: 20,verticalPadding: 3,radius: 5)
            
            
        }
    }
    var placedView : some View {
        Text("Placed at \(myOrder.orderPlacedDatetime)")
            .font(FontConstants.primaryRegularTitle11)
    }
}


