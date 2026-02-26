//
//  FavoriteViewModel.swift
//  PawWalker
//
//  Created by shagar on 06/04/25.
//

import SwiftUI
import Combine

class FavoriteViewModel :  ObservableObject {
    @Published var selectedCategory : FavoriteType = .clinic
    {
        didSet {
            if selectedCategory == .product {
                fetchProductFavorites()
            }
            else {
                fetchClnicFavorites()
            }
        }
    }
    @Injected var apiClient : ApiClientProtocol
    @Published var favoritesProductList : [FavoiteProduct] = []
    @Published var favoritesClinicList : [FavoriteClinic] = []
    @Published var navigateToSlotBooking : Bool = false
    @Published var selectedClinicId : String = TextResource.empty
    private var cancellables = Set<AnyCancellable>()
    @Published var isLoading : Bool = false
    
    func fetchProductFavorites() {
        if Connectivity.isConnectedToInternet {
           isLoading = true
            apiClient.APIRequest(router: .getProductFavorite, responseType: FavoriteProductModel.self)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? error.localizedDescription)
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    if let result = response.result {
                        self.favoritesProductList = result
                    }
                    else {
                        self.favoritesProductList.removeAll()
                    }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func fetchClnicFavorites() {
        if Connectivity.isConnectedToInternet {
            self.isLoading = true
            apiClient.APIRequest(router: .getClinicFavorite, responseType: FavoriteClinicModel.self)
                .sink {[weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self?.isLoading = false
                        break
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    if let result = response.result {
                        self.favoritesClinicList = result
                    }
                    else {
                        self.favoritesClinicList.removeAll()
                    }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func deleteProductFromFavorites(productId : String,variantId : String) {
        if Connectivity.isConnectedToInternet {
            self.isLoading = true
            let param : [String : Any] = [ApiParameters.id : productId,ApiParameters.variantId: variantId,ApiParameters.favoriteItem : FavoriteType.product.rawValue]
            apiClient.APIRequest(router: .deleteFavorite, parameters: param, responseType: SimpleResponse.self)
                .sink { completion in
                    switch  completion {
                    case .finished:
                        break
                    case .failure(_):
                      self.isLoading = false
                        break
                        
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    ToastCenter.shared.showToast(response.message ?? "successfully deleted from favorites",type: .error)
                    self.fetchProductFavorites()
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func deleteClinicFromFavorites(clinicId : String) {
        if Connectivity.isConnectedToInternet {
            self.isLoading = true
            let param : [String : Any] = [ApiParameters.id : clinicId,ApiParameters.favoriteItem : FavoriteType.clinic.rawValue]
            apiClient.APIRequest(router: .deleteFavorite, parameters: param, responseType: SimpleResponse.self)
                .sink { completion in
                    switch  completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isLoading = false
                        if let errorMessage = error.backendError?.message {
                            ToastCenter.shared.showToast(errorMessage,type: .error)
                        }
                        break
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    ToastCenter.shared.showToast(response.message ?? "successfully deleted from favorites",)
                    self.fetchClnicFavorites()
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func postToCart(productId : String, varaintId : String,quantity : Int) {
        if Connectivity.isConnectedToInternet {
            self.isLoading = true
            let params : [String : Any] = [
                ApiParameters.productId : productId,
                ApiParameters.productVariantId : varaintId,
                ApiParameters.quantity : quantity
            ]
            apiClient.APIRequest(router: .addTocat, parameters: params, responseType: AddToCartModel.self)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.isLoading = false
                        if let errorMessage = error.backendError?.message {
                            ToastCenter.shared.showToast(errorMessage,type: .error)
                        }
                        break
                    }
                } receiveValue: { response in
                    if let result = response.result {
                        let cartCount = result.cart.count
                        EventHandler.cartCountSubject.send(cartCount)
                        self.isLoading = false
                        ToastCenter.shared.showToast(TextResource.addedToCartAlert,type: .success)
                    }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
}
