//
//  ProductReviewScreen.swift
//  PawWalker
//
//  Created by shagar on 13/05/25.
//

import SwiftUI

struct ProductReviewScreen : View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var viewModel : ProductDetailsViewModel
    
    var body: some View {
        VStack {
            reviewList
                .padding(.all,20)
        }
        .topBarView(titleView: ViewUtils.shared.titleView(title: TextResource.productReviews),
                    leftButtons: ViewUtils.shared.backButtonView(action: {
            self.mode.wrappedValue.dismiss()
        }))
    }
    var reviewList : some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.reviewList,id: \.reviewId) {item in
                    ReviewView(review: item)
                }
            }
        }
    }
}
