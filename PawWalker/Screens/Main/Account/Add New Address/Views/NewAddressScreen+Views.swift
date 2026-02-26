//
//  NewAddressScreen+Views.swift
//  PawWalker
//
//  Created by shagar on 20/02/25.
//

import SwiftUI
extension NewAddressScreen {
    
    var fullNameView : some View {
        LabelTextField(
            label: TextResource.fullName,
            placeHolder: TextResource.fullNamePlaceHolder,
            isFullWidth: true,
            height: 45,
            borderRadius: 5,
            text: $viewModel.fullName
        )
     
    }
    var mobileNumberView : some View {
        LabelTextField(
            label: TextResource.mobileNumber,
            placeHolder: TextResource.enterMobileNumber,
            isFullWidth: true,
            isMobileNumber: true,
            height: 45,
            borderRadius: 5 ,
            text: $viewModel.mobileNumber,
            keyBoardType: .numberPad
        )
     
    }
    var addressLineView : some View {
        LabelTextField(
            label: TextResource.addressLine,
            placeHolder: TextResource.addressLinePlaceHolder,
            isFullWidth: true,
            height: 45,
            borderRadius: 5,
            text: $viewModel.addressLine
        )
        
    }
    
    var countryView : some View {
        LabelTextField(
            label: TextResource.country,
            placeHolder: TextResource.countryPlaceHolder,
            isFullWidth: true,
            height: 45,
            borderRadius: 5,
            text: $viewModel.country
        )
        
    }
    var cityView : some View {
        LabelTextField(
            label: TextResource.city,
            placeHolder: TextResource.enterYourCity,
            isFullWidth: true,
            height: 45,
            borderRadius: 5 ,
            text: $viewModel.city
        )
    
    }
    
    var emailView : some View {
        LabelTextField(
            label: TextResource.email,
            placeHolder: TextResource.emailPlaceHolder,
            isFullWidth: true,
            height: 45,
            text: $viewModel.email
        )
    }
    
    var stateView : some View {
        LabelTextField(
            label: TextResource.state,
            placeHolder: TextResource.statePlaceHolder,
            isFullWidth: true,
            height: 45,
            text: $viewModel.state
        )
    }
    
    var zipCodeView : some View {
        LabelTextField(
            label: TextResource.zipCode,
            placeHolder: TextResource.zipCodePlaceHolder,
            isFullWidth: true,
            isMobileNumber: false,
            height: 45,
            text: $viewModel.zipcode,
            keyBoardType: .numberPad
        )
    }
    var saveButtonView : some View {
        Button(action: {
            if viewModel.isEdit {
                viewModel.editAddress { status in
                    if status {
                        self.coordinator?.popToRoot()
                    }
                }
            }
            else {
                viewModel.handleSaveAddress(completion: {status in
                    if status {
                        self.coordinator?.popToRoot()
                    }
                })
            }
        }, label: {
            Text(viewModel.isEdit ? TextResource.update : TextResource.save)
                .primaryButtonStyle(fullWidth : true)
                .padding(.horizontal,40)
        })
        .padding(.top,25)
    }
}
