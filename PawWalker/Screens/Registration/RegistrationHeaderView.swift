//
//  RegistrationHeaderView.swift
//  PawWalker
//
//  Created by shagar on 07/11/24.
//

import SwiftUI

struct RegistrationHeaderView: View {
    var showBackButton : Bool = false
    var completionHandler : () -> () = {}
    var body: some View {
        ZStack {
            backgroundImage
            VStack(spacing : 0){
                Spacer()
                appLogo
//                welcomeMessage
//                    .padding(.top,20)
            }
        }
        .frame(height: UIScreen.screenHeight / 2.4)
        .ignoresSafeArea()
    }
    private var backgroundImage : some View {
              Rectangle()
            .frame(maxWidth : .infinity)
            .foregroundStyle(Color(.primaryBg))
            
    }
    private var appLogo : some View {
        Image(ImageResource.petQuraLogo)
            .resizable()
            .scaledToFit()
            .frame(width: 300,height: 200)
    }
    private var welcomeMessage : some View {
        Text(TextResource.welcomeMessage)
            .font(FontConstants.primarySemiBoldTitle30)
            .foregroundStyle(Color.primaryButton)
            .padding(.bottom,.padding10)
    }
    private var backButton : some View {
        Image(ImageResource.backButton)
            .padding(.top,40)
            .padding(.leading,10)
            .onTapGesture {
                completionHandler()
            }
    }
}
