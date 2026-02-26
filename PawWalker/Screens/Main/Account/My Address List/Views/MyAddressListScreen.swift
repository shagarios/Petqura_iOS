//
//  MyAddressList.swift
//  PawWalker
//
//  Created by shagar on 26/02/25.
//

import SwiftUI

struct MyAddressListScreen: View {
    @StateObject var viewModel : MyAddressListViewModel
    init(coordinator : AccountCoordinator) {
        self._viewModel = StateObject(wrappedValue: MyAddressListViewModel(coordinator: coordinator))
    }
    var body: some View {
        VStack {
            newAddressView
                .padding(.top,20)
            addressListView
                .padding(.top,20)
        }
        .task {
            viewModel.getAddressList()
        }
        .topBarView(titleView: ViewUtils.shared.titleView(title: TextResource.myAddress),
                    leftButtons: ViewUtils.shared.backButtonView {
            viewModel.coordinator?.pop()
        })
        .alert(TextResource.makeThisAddressAsPrimary, isPresented: $viewModel.showMakeAsPrimaryAlert) {
            Button(TextResource.ok) {
                if let address = viewModel.selectedAddress {
                    viewModel.makeAsPrimary(address: address)
                }
                else {
                    viewModel.showMakeAsPrimaryAlert = false
                }
                
            }
            Button(TextResource.cancel) {
                viewModel.showMakeAsPrimaryAlert = false
            }
        }
    }
    
    private var newAddressView: some View {
        Button(action: {
           // viewModel.coordinator?.push(.addNewAddress(isEdit: false, address: nil))
            viewModel.coordinator?.push(.location(isAccountRelated: true))
        }, label: {
            Text(TextResource.addNewAddress)
                .font(FontConstants.primaryRegularTitle14)
                .foregroundStyle(Color(ColorResource.primaryButton))
                .applyOutline(verticalPadding : 10,hortizontalPadding: 20,
                              cornerRadius: 15,outlineColor: Color(ColorResource.primaryButton))
        })
    }
    private var addressListView : some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.addressList,id: \.id) { item in
                    AddressItemView(
                        item : item,
                        completion: { address, action in
                            viewModel.handleAddressActions(address: address, action: action)
                        }
                    )
                        .padding(.bottom,10)
                    Divider()
                }
            }
        }
    }
}


struct AddressItemView : View {
    var item : Address
    var completion : (Address,AddressActionType) -> ()
    var body: some View {
        VStack(alignment: .leading,spacing: 0){
            addressTypeView
            nameView
            addressView
            
        }
        .padding(.horizontal,20)
    }
    
    private var addressTypeView : some View {
        HStack {
            Text(item.addressType ?? TextResource.empty)
                .font(FontConstants.primaryMediumTitle12)
                .makeBackgroundView(color: Color(ColorResource.littleGray),horizontalPadding: 10,verticalPadding: 5,radius: 5)
         
            Text(TextResource.primary)
                .font(FontConstants.primaryMediumTitle12)
                .makeBackgroundView(color: Color(ColorResource.littleGray),horizontalPadding: 10,verticalPadding: 5,radius: 5)
                .isRemove(!isDefaultAddress())
            Spacer()
            menuView
            
        }
    }
    private var nameView : some View {
        Text(item.fullname ?? TextResource.empty)
            .font(FontConstants.primaryMediumTitle14)
            .padding(.top,10)
    }
    private var addressView : some View {
        Text(item.address ?? TextResource.empty)
            .font(FontConstants.primaryRegularTitle12)
            .padding(.top,5)
            .lineLimit(3)
    }
    private var menuView : some View {
        Menu(content: {
            Button(action: {
                completion(item, .makePrimary)
            }, label: {
                Text(TextResource.setAsPrimaryAddress)
            })
            Button(action: {
                completion(item, .edit)
            }, label: {
                Text( TextResource.edit)
            })
            Button(action: {
                completion(item, .delete)
            }, label: {
                Text(TextResource.delete)
                    .foregroundStyle(Color.red)
            })
        }, label: {
            Image(ImageResource.editIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 24,height: 24)
        }
        )
    }
    func isDefaultAddress() -> Bool {
        return item.defaultAddress ?? false
    }
}

enum AddressActionType : String {
    case makePrimary
    case edit
    case delete
}
