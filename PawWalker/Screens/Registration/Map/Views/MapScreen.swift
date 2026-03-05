//
//  MapScreeen.swift
//  PawWalker
//
//  Created by shagar on 13/11/24.
//

import SwiftUI

struct MapScreen: View {
    @StateObject var viewModel : MapViewModel
    @Environment(\.dismiss) var dismiss
    weak var coordinator : AccountCoordinator?
    var isAccountRelated: Bool = false
    init(address: Address? = nil,isAccountRelated: Bool,coordinator : AccountCoordinator?) {
        _viewModel = StateObject(wrappedValue: MapViewModel(address: address))
        self.isAccountRelated = isAccountRelated
        self.coordinator = coordinator
    }
    var body: some View {
        ZStack {
            VStack {
                GoogleMapsView(viewModel: viewModel)
                    .overlay(
                        placeSearchView
                        .padding(.top,10)
                             ,alignment: .top)
                infoView
            }
        }
        .sheet(isPresented: $viewModel.showingPlacesAutocomplete) {
            PlaceAutocompleteView(selectedPlace: $viewModel.selectedPlace,
                                  isPresented: $viewModel.showingPlacesAutocomplete)
                }
        .if(isAccountRelated == false, transform: { view in
            view.hideNavigationBar()
        })
        .makeWithLoader(isLoading: $viewModel.isLoading)
        .topBarView(titleView: ViewUtils.shared.titleView(title: "Select Your Location"),
                    leftButtons: ViewUtils.shared.backButtonView {
           dismiss()
        })
    }
    private var placeSearchView : some View {
        HStack {
            Image(ImageResource.location)
                .foregroundStyle(Color.darkGray)
                .padding(.leading,10)
            Button(action: {
                viewModel.showingPlacesAutocomplete = true
            },
                   label: {
                Text("Search your City or Area")
                    .foregroundStyle(Color.darkGray)
            })
            
            Spacer()
        }
        .frame(height: 50)
        .background(Color.white)
        .padding(.horizontal,20)
    }
    private var infoView : some View {
        VStack(alignment: .leading){
            HStack {
                Image(.currentLocationPin)
                VStack(alignment: .leading) {
                    Text(viewModel.addressLine)
                        .font(FontConstants.primaryMediumTitle14)
                }
            }
            .padding(.top,20)
            Button(action: {
                if isAccountRelated {
                    let address = viewModel.makeAccountAddress()
                    if viewModel.addressDetails == nil {
                        coordinator?.push(.addNewAddress(isEdit: false,
                    address: address))
                    }
                    else {
                        coordinator?.push(.addNewAddress(isEdit: true, address: address))
                    }
               
                }
                else {
                    UserDefaults.standard.set(true, forKey: UserDefaultConstants.mapShowed.rawValue)
                    viewModel.saveLocationToLocalDatabase(result: viewModel.addressData) {
                        if isAccountRelated  {
                            coordinator?.pop()
                        }
                        else {
                            dismiss()
                        }
                    }
                }
            }, label: {
                Text(TextResource.confirm)
                    .primaryButtonStyle(fullWidth : true)
            })
            .padding(.top,30)
            .padding(.bottom,20)
           
        }
        .padding(.horizontal,30)
    }
}
