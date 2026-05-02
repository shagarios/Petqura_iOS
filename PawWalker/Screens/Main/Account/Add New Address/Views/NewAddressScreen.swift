//
//  AddNewAddressScreen.swift
//  PawWalker
//
//  Created by shagar on 20/02/25.
//

import SwiftUI
import KeyboardAware

struct NewAddressScreen: View {
    @StateObject var viewModel :  NewAddressViewModel
    weak var coordinator : AccountCoordinator?
    init(isEdit : Bool, address: Address?,coordinator : AccountCoordinator) {
       _viewModel = StateObject(wrappedValue: NewAddressViewModel(isEdit: isEdit, address: address))
        self.coordinator = coordinator
    }
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading,spacing: 15) {
                Menu(content: {
                    addressTypeList
                }, label: {
                    addressLabelView
                        .padding(.top,20)
                })
              
                fullNameView
                mobileNumberView
                //emailView
                addressLineView
                cityView
                stateView
                zipCodeView
                saveButtonView
                Spacer()
            }
        }
        .keyboardAware()
        .padding(.horizontal,20)
        .topBarView(titleView: ViewUtils.shared.titleView(title: viewModel.isEdit ? TextResource.editAddress : TextResource.addNewAddress),
            leftButtons: ViewUtils.shared.backButtonView(action: {
            coordinator?.pop()
        }))
    }
    private var addressLabelView : some View {
        VStack(alignment: .leading,spacing: 0) {
            Text(TextResource.addressLabel)
                .foregroundStyle(Color(ColorResource.darkGray))
                .font(FontConstants.primaryRegularTitle12)
                .padding(.leading,5)
                .padding(.bottom,5)
            HStack {
                Text(viewModel.selectedAddressType.rawValue)
                    .foregroundStyle(Color.black)
                    .font(FontConstants.primaryRegularTitle14)
                    
                Spacer()
                Image(ImageResource.downArrow)
                
            }
            .applyOutline(cornerRadius : 5)
        }
        
    }
    private var addressTypeList : some View {
        VStack {
            ForEach(viewModel.addrressTypeList,id: \.self) { item in
                Button(item.rawValue,action: {
                    viewModel.selectedAddressType = item
                })
            }
        }
    }
}

enum AddressType : String {
    case home = "Home"
    case work = "Work"
    case other = "Other"
}

