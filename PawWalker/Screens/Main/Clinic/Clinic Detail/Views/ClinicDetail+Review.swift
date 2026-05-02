//
//  ClinicDetail+Review.swift
//  PawWalker
//
//  Created by shagar on 13/05/25.
//

import SwiftUI

extension ClinicDetailScreen {
    var ratingView : some View {
        HStack {
            RatingView(rate: viewModel.averageReviewRating,starSize: 20,starPadding: 5)
            Text("(\(viewModel.reviewList.count))")
                .font(FontConstants.primaryRegularTitle16)
            Spacer()
            Button(action: {
               viewModel.showReviewBottomSheet = true
            }, label: {
                Text(TextResource.addReview)
                    .foregroundStyle(Color.primaryButton)
                    .font(FontConstants.primaryMediumTitle14)
            })
        }
        .padding(.top,15)
    }
    var reviewView : some View {
        VStack (alignment: .leading){
            if viewModel.reviewList.isEmpty {
                Spacer()
                    emptyReviewView
            }
            else {
                reviewList
            }
        }
    }
    
    var reviewList : some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.reviewList,id: \.reviewId) {item in
                    ReviewView(review: item)
                }
            }
        }
    }
    var emptyReviewView : some View {
        VStack{
            Text(TextResource.noReviews)
                .font(FontConstants.primaryMediumTitle16)
                .foregroundStyle(.darkGray)
                .padding(.top,100)
        }
    }
  
}
