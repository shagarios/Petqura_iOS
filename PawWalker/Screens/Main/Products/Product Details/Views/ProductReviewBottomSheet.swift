//
//  ProductReviewBottomSheet.swift
//  PawWalker
//
//  Created by shagar on 11/08/25.
//

import SwiftUI
import CTRating

struct ProductReviewAlert: View {
    @State var currentRating : Int = 0
    @State var reviewText: String = TextResource.empty
    var placeHolder: String = TextResource.productReviewCaption
    var sumbitAction : (String,Int) -> ()
    var closeAction : () -> ()
    var body: some View {
        VStack(alignment: .leading,spacing: 0){
            HStack {
                Text(UserSessionManager.shared.name)
                    .foregroundStyle(Color.darkGray)
                    .font(FontConstants.primaryRegulatTitle18)
                Spacer()
                Button(action: {
                    closeAction()
                }, label: {
                    Image(.closeGrayIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16,height: 16)
                        .padding(.trailing,10)
                })
            }
            CTRating(maxRating: 5, currentRating: $currentRating,width: 20)
                .padding(.top,5)
        
            TextEditor(text: $reviewText)
                .frame(height: 160) // Set a fixed height or use modifiers for dynamic height
                .padding(.all,.padding10)
                .cornerRadius(8)
                .overlay(sendButton,
                         alignment: .bottomTrailing)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.top,10)
                .overlay(content: {
                    Text(placeHolder)
                        .foregroundStyle(Color.gray.opacity(0.5))
                        .isRemove(reviewText.isNotEmpty)
                })

        }
        .padding(.horizontal,25)
        .padding(.vertical,25)
        .background(Color.white)
        .cornerRadius(10)
         .onTapGestureForced {
             UIApplication.shared.endEditing()
         }
    }
 
    private var sendButton: some View {
        Button(action: {
            sumbitAction(reviewText, currentRating)
        }, label: {
            Image(.sendArrow)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25,height: 25)
                .foregroundStyle(Color.primaryButton)
                .padding(.trailing,10)
                .padding(.bottom,10)
        })
    }
}

