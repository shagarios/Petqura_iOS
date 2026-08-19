//
//  FavoriteViewModel.swift
//  PawWalker
//
//  Created by shagar on 06/04/25.
//

import SwiftUI
import Combine

class FavoriteViewModel : ClinicListViewModel {
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
    init() {
        super.init(coordinator: ClinicCoordinator())
    }
    private var cancellables = Set<AnyCancellable>()
    @Published var favoritesProductList : [FavoiteProduct] = []
    @Published var favoritesClinicList : [FavoriteClinic] = []
    @Published var clinicPage : Int = 1
    @Injected var connectivity : NetworkMonitor
    @Published var hasNextClinicSuggention : Bool = false
    @Published var suggetionsPage: Int = 1
    @Published var suggetionClinicList: [Clinic] = []
    @Published var showCartPage : Bool = false
    func fetchProductFavorites() {
        if Connectivity.isConnectedToInternet {
           isLoading = true
            apiClient.APIRequest(router: .getProductFavorite, responseType: FavoriteProductModel.self)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self?.isLoading = false
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
                        self.favoritesClinicList = result.favourites
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
                    self.suggetionsPage = 1
                    self.fetchClinicSuggetions()
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
                        guard let cartCount = result.cart?.count else {return}
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
    func fetchClinicSuggetions() {
        if connectivity.isConnectedToInternet {
            if suggetionsPage == 1 {
                suggetionClinicList.removeAll()
            }
            apiClient.APIRequest(router: .favoriteClinicSuggetions(page: suggetionsPage),
                                 responseType: ClinicSuggetionsModel.self)
                .sink {  [weak self] completion in
                    switch completion {
                    case .failure(let error):
                        self?.isLoading = false
                        if let errorMessage = error.backendError?.message {
                            ToastCenter.shared.showToast(errorMessage,type: .error)
                        }
                        break
                    case .finished:
                        break
                    }
                } receiveValue: { response in
                    print(response)
                    self.suggetionClinicList.append(contentsOf: response.result.suggestions)
                    self.hasNextClinicSuggention = response.result.hasNext ?? false
                }
                .store(in: &cancellables)

        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
}
