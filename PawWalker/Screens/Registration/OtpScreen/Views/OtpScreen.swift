//
//  OtpScreen.swift
//  PawWalker
//
//  Created by shagar on 09/11/24.
//

import SwiftUI
import OTPView

struct OtpScreen: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel : OtpViewModel
    init(mobileNumber: String,coordinator : AccountCoordinator,firstName: String,email: String) {
        self._viewModel = StateObject(wrappedValue: OtpViewModel(mobileNumber: mobileNumber,
                                                                 coordinator: coordinator
                                                                 ,firstName: firstName,email: email))
    }
    var body: some View {
        VStack (spacing : 0){
            RegistrationHeaderView(showBackButton: true) {
                viewModel.coordinator?.pop()
            }
            VStack(spacing: 0){
                Text(TextResource.checkYourPhone)
                    .font(FontConstants.primaryMediumTitle18)
                    .padding(.top,40)
                Text(TextResource.otpSentMessage)
                    .font(FontConstants.primaryRegularTitle16)
                    .foregroundStyle(Color(ColorResource.semiDarkGray))
                    .padding(.top,10)
                otpView
                    .padding(.top,30)
                confirmButton
                sendAgainButton
            }
            Spacer()
                
        }
        .makeWithLoader(isLoading: $viewModel.isLoading)
        .edgesIgnoringSafeArea(.top)
        .onTapGestureForced {
            UIApplication.shared.endEditing()
        }
        .keyboardAware()
    }
    
    private var otpView : some View {
        OTPFieldView(numberOfFields: 4, otp: $viewModel.otp)
    }
    private var confirmButton : some View {
        Button(action: {
            if viewModel.isOtpValidated {
                //viewModel.navigateToMap = true
                viewModel.verifyOtp()
            }
        }, label: {
            Text(TextResource.verify)
        })
        .primaryButtonStyle(width : 200,active: viewModel.isOtpValidated)
        .padding(.top,50)
        }
    private var sendAgainButton : some View {
        Button(action: {
            viewModel.registerWithMobileNumber()
        }, label: {
            Text(TextResource.sendAgain)
                .outlineButtonStyle(width : 200)
        })
        .padding(.top,20)
    }
    

}
