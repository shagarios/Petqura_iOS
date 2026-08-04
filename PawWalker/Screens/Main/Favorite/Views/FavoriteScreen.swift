//
//  FavoriteScreen.swift
//  PawWalker
//
//  Created by shagar on 06/04/25.
//

import SwiftUI

struct FavoriteScreen : View {
    @StateObject var viewModel = FavoriteViewModel()
    weak var coordinator : FavoriteCoordinator?
    init(coordinator : FavoriteCoordinator) {
        self.coordinator = coordinator
    }
    var body: some View {
        VStack(spacing: 0) {
            headerView
                .padding(.top,10)
            if viewModel.selectedCategory == .product {
                productView
            }
            else {
                clinicView
            }
            Spacer()
            suggetionNameView
                .padding(.bottom,10)
                .isRemove(viewModel.suggetionClinicList.count == 0)
            clinicSuggetionListView
            .padding(.bottom,90)
        }
        .task{
            viewModel.fetchClnicFavorites()
            viewModel.fetchClinicSuggetions()
        }
        .makeWithLoader(isLoading: $viewModel.isLoading)
        .padding(.horizontal,20)
        .topBarView(titleView: coordinator?.appCoordinator?.titleView(),
                    rightButtons:
                ViewUtils.shared.cartButtonView(count: coordinator?.appCoordinator?.cartItemCount ?? 0,
                            action: {
            coordinator?.appCoordinator?.navigateToCart = true
        }))
        
    }
    
    private var headerView : some View {
        VStack {
            HStack {
                ForEach(FavoriteType.allCases,id: \.self) { item in
                    SegmentView(name: item.displayName,
                                isSelected: viewModel.selectedCategory == item,
                                horizontalSpace: 20,verticalSpace: 5) {
                        viewModel.selectedCategory = item
                    }
                }
                Spacer()
                
            }
        }
    }
    
    @ViewBuilder
    private var productView : some View {
        if viewModel.favoritesProductList.isEmpty {
            Spacer()
            emptyProductView
            Spacer()
        }
        else {
            favoriteProductListView
        }
    }
    @ViewBuilder
    private var clinicView : some View {
        if viewModel.favoritesClinicList.isEmpty {
            Spacer()
            emptyClinicView
            Spacer()
        }
        else {
            favoriteClinicListView
        }
       
    }
    
    private var favoriteProductListView : some View {
        ScrollView(showsIndicators: false){
            LazyVStack{
                ForEach(viewModel.favoritesProductList,id: \.id) {item in
                    FavoriteProductView(product: item,deleteProductCallBack: { favorite in
                        viewModel.deleteProductFromFavorites(productId: favorite.productID ?? "", variantId: favorite.variants?.productVariantID ?? "")
                    },cartCallBack: { favorite in
                        viewModel.postToCart(productId: favorite.productID ?? "", varaintId: favorite.variants?.productVariantID ?? "", quantity: 1)
                    })
                        .padding(.top,10)
                    Divider()
                }
            }
        }
    }
    private var emptyClinicView : some View {
        VStack(alignment: .center){
            Image(.favoritePlaceholder)
            Text("Mark your pet's favourite clinics")
                .font(FontConstants.primaryMediumTitle16)
                .padding(.top,40)
        }
    }
 
    private var emptyProductView : some View {
        VStack(alignment: .center){
            Image(.favoriteStorePlaceHolder)
            Text("Mark your pet's favourite products")
                .font(FontConstants.primaryMediumTitle16)
                .padding(.top,40)
        }
    }
    private var favoriteClinicListView : some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(viewModel.favoritesClinicList,id: \.clinicID) {item in
                    FavoriteClinicView(clinic: item, appointmentCallBack: {clinicId in
                        viewModel.selectedClinicId = clinicId
                       // coordinator?.push(.slotBooking(clinicId:  viewModel.selectedClinicId))
                        coordinator?.appCoordinator?.selectedClinicId = item.clinicID
                        coordinator?.appCoordinator?.navigateToSlotBookingScreen = true
                    },deleteCallback: { clinic in
                        viewModel.deleteClinicFromFavorites(clinicId: clinic.clinicID)
                    })
                        .padding(.top,10)
                    Divider()
                }
            }
        }
    }
}
