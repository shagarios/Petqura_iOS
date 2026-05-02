//
//  ProductDetail+Reviews.swift
//  PawWalker
//
//  Created by shagar on 13/05/25.
//

import SwiftUI

extension ProductDetailsScreen {
    var ratingView : some View {
        HStack {
            RatingView(rate: viewModel.averageRating,starSize: 20,starPadding: 5)
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
            reviewTitleView
            if viewModel.reviewList.isEmpty {
                emptyReviewView
            }
            else {
                reviewList
                    .frame(height: 200)
            }
        }
    }
    
    var reviewTitleView : some View {
        HStack {
            Text(TextResource.reviews)
                .font(FontConstants.primaryMediumTitle16)
                .foregroundStyle(.black)
            Spacer()
            Button(action: {
                viewModel.showReviewPage = true
            }, label: {
                Text(TextResource.viewAll)
                    .font(FontConstants.primaryMediumTitle14)
                    .foregroundStyle(ColorContants.softYellow)
            })
            .isRemove(viewModel.reviewList.isEmpty)
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
        Text(TextResource.noReviews)
            .font(FontConstants.primaryMediumTitle12)
            .foregroundStyle(.darkGray)
    }
}


struct ReviewView : View {
    let review : Review
    var body: some View {
        VStack (alignment: .leading){
            headerView
            commentView
        }
        .padding(.all,15)
        .background(
            RoundedRectangle(cornerRadius: 7)
                .stroke(lineWidth: 1)
                .foregroundStyle(ColorContants.borderGray)
        )
    }
    private var headerView : some View {
        HStack{
            profileView
            name
            Spacer()
            ratingView
        }
    }
    private var profileView : some View {
        Image(ImageResource.profileIcon)
            .resizable()
            .frame(width: 32,height: 32)
    }
    private var name : some View {
        Text(review.user ?? "")
            .font(FontConstants.primaryMediumTitle14)
            .foregroundStyle(Color.black)
    }
    private var ratingView : some View {
        RatingView(rate: rating())
    }
    
    private var commentView : some View {
        Text(review.reviewContent ?? "")
            .font(FontConstants.primaryRegularTitle12)
            .foregroundStyle(Color.black)
    }
    
    func rating() -> Double {
        let rate = review.reviewStarCount ?? 0
        return Double(rate) 
    }
}

