//
//  ClinicRatingBottomSheet.swift
//  PawWalker
//
//  Created by shagar on 06/03/26.
//

import SwiftUI

struct ClinicRatingBottomSheet: View {
    var body: some View {
        VStack{
            HStack {
                Spacer()
                closeButton
            }
        }
        
    }
    private var closeButton : some View {
        Button(action: {
            
        }, label: {
            Image(ImageResource.closeGrayIcon)
        })
    }
    private var titleView : some View {
        VStack {
            Text("Hey \(UserSessionManager.shared.user?.name ?? ""),")
            Text(TextResource.clinicReviewDiscription)
                .padding(.top,10)
        }
        .font(FontConstants.primaryRegularTitle12)
        .foregroundStyle(Color.black)
        
    }
}

#Preview {
    ClinicRatingBottomSheet()
}
