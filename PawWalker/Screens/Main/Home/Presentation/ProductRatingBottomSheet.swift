//
//  ProductRatingBottomSheet.swift
//  PawWalker
//
//  Created by shagar on 23/08/26.
//

import SwiftUI
import CTRating

struct ProductRatingBottomSheet: View {
    @ObservedObject var viewModel : HomeScreenViewModel
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Spacer()
                closeButton
                    .padding(.top,10)
            }
            titleView
            rateView
                .padding(.bottom,20)
            HStack {
                imageView
                detailView
            }
            textFieldView
          comfirmView
                .padding(.top,20)
        }
        .keyboardAware()
        .padding(.horizontal,15)
        .onTapGestureForced {
            UIApplication.shared.endEditing()
        }
        
    }
    private var closeButton : some View {
        Button(action: {
            viewModel.closeProductReviewSheet()
        }, label: {
            Image(ImageResource.closeGrayIcon)
        })
    }
    private var titleView : some View {
        VStack(alignment : .leading) {
            Text("Hey \(UserSessionManager.shared.user?.name ?? ""),")
            Text(TextResource.productReviewDiscription)
        }
        .font(FontConstants.primaryRegularTitle12)
        .foregroundStyle(Color.black)
        
    }
    private var rateView: some View {
        CTRating(maxRating: 5, currentRating: $viewModel.productRating,width: 20)
            .padding(.top,5)
    }
    
    private var imageView : some View {
            VStack {
                ImageURLView(url: self.viewModel.pendingReview?.entityImage ?? "")
                    .frame(width: 100,height: 100)
            }
            .itemBorderStyle()
    }
    private var detailView : some View {
        VStack(alignment: .leading){
            Text(self.viewModel.pendingReview?.entityName ?? "")
                .font(FontConstants.primaryMediumTitle14)
            itemView(key: "Quantity", Value: viewModel.pendingReview?.entityQuantity ?? "")
//            itemView(key: "Date", Value: viewModel.pendingReview?.referenceDate ?? "")
//            itemView(key: "Time", Value: viewModel.pendingReview?.referenceTime ?? "")
        }
    }
    func itemView(key: String,Value: String) -> some View {
        Text("\(key): \(Value)")
            .font(FontConstants.primaryRegularTitle12)
            .foregroundStyle(Color.black)
    }
    private var textFieldView : some View {
        TextEditor(text: $viewModel.productReviewText)
            .frame(height: 100) // Set a fixed height or use modifiers for dynamic height
            .padding(.all,.padding10)
            .cornerRadius(8)
            .font(FontConstants.primaryRegularTitle12)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.top,10)
            .overlay(alignment: .topLeading, content: {
                Text("Let pet parents know your experience")
                    .font(FontConstants.primaryRegularTitle12)
                    .foregroundStyle(Color.gray.opacity(0.5))
                    .isRemove(viewModel.productReviewText.isNotEmpty)
                    .padding(.top,30)
                    .padding(.leading,10)
            })
    }
    private var comfirmView : some View {
        Button(action: {
            UIApplication.shared.endEditing()
            viewModel.submitProductReviewToServer()
        }, label: {
            Text(TextResource.confirm)
                .primaryButtonStyle(fullWidth: true)
        })
    }
}


