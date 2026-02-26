//
//  MobNumberRegistrationView.swift
//  PawWalker
//
//  Created by shagar on 06/11/24.
//

import SwiftUI

struct MobileNumberRegistrationView: View {
    @StateObject var viewModel : MobileNumberRegistrationViewModel
    init(coordinator : AccountCoordinator) {
        self._viewModel = StateObject(wrappedValue: MobileNumberRegistrationViewModel(coordinator: coordinator))
    }
    @State private var errorMessage: String?
    var body: some View {
        ScrollView {
            VStack(spacing : 0) {
                RegistrationHeaderView()
                VStack(spacing : 0){
                    Text(TextResource.registerWithMobileNumber)
                        .font(FontConstants.primaryMediumTitle18)
                        .padding(.top,20)
                    LabelTextField(label: TextResource.name,
                                   placeHolder: TextResource.enterName,isFullWidth: true,
                                   text: $viewModel.name)
                    .padding(.top,20)
                    .padding(.horizontal,10)
                    
                    LabelTextField(label: TextResource.mobileNumber,
                            placeHolder: TextResource.enterMobileNumber,
                            isFullWidth: true, isMobileNumber: true,
                                   text: $viewModel.mobileNumber,
                                   keyBoardType: .numberPad)
                        .padding(.horizontal,10)
                        .padding(.top,20)
                    
                    LabelTextField(label: TextResource.email,
                            placeHolder: TextResource.emailPlaceHolder,
                            isFullWidth: true, text: $viewModel.email,
                                   keyBoardType: .emailAddress)
                        .padding(.horizontal,10)
                        .padding(.top,20)
                    Button(action: {
                        viewModel.handleMobileNumberValidation()
                        
                    }, label: {
                        Text(TextResource.confirm)
                            .primaryButtonStyle(width : 200)
                    })
                    .padding(.top,30)
                    Spacer()
                }
                .padding(.horizontal,20)
            }
        }
        .frame(alignment: .leading)
        .onTapGestureForced {
            UIApplication.shared.endEditing()
        }
        .keyboardAware()
        .ignoresSafeArea()
        .makeWithLoader(isLoading: $viewModel.isLoading)
    }
    
}

