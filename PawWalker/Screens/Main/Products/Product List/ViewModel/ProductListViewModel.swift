//
//  ProductListViewModel.swift
//  PawWalker
//
//  Created by shagar on 18/01/25.
//
import SwiftUI
import Combine

class ProductListViewModel : ObservableObject {
    @Injected var apiClient : ApiClientProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published var productList : [Product] = []
    @Published var filteredProductList : [Product] = []
    @Published var selectedVariant : Variant?
    @Published var navigateToProductDetail : Bool = false
    @Published var selectedProduct : Product?
    @Published var page : Int = 1
    @Published var searchPage : Int = 1
    @Published var hasNext : Bool = false
    @Published var searchHasNext : Bool = false
    @Published var shouldSearch = true
    @Published var searchText : String = TextResource.empty {
        didSet {
            if searchText.isEmpty {
                shouldShowEmptySearchView = false
            }
            searchSubject.send(searchText)
        }
    }
    @Published var categoryId : String = TextResource.empty
    @Published var searchSubject = PassthroughSubject<String,Never>()
    @Published var showFilterList : Bool = false
    @Published var shouldShowEmptyView : Bool = false
    @Published var shouldShowEmptySearchView : Bool = false
    @Published var isLoading : Bool = false
    @Injected var productCartUseCase : ProductCartUseCaseProtocol
    @Published var showAlert : Bool = false
    @Published var alertMessage : String = ""
    @Published var selectedProductIdentiy : ProductIdentity?
    @Published var selectedProductVariant : Variant?
    @Published var showCartPage : Bool = false
    @Published var showLoginRequiredAlert : Bool = false
    @Published var shouldShowLoader : Bool = false
     var cartDetailUseCase : CartDetailsUsecase?
    init(cartDetailUseCase : CartDetailsUsecase? = nil) {
        setupSearchPublisher()
        self.cartDetailUseCase = cartDetailUseCase

    }
   
    func setupSearchPublisher() {
        searchSubject
            .debounce(for: .seconds(1.5), scheduler: DispatchQueue.main)
            .sink { searchText in
                guard self.shouldSearch else {
                    self.shouldSearch = true
                    return
                }
                self.filteredProductList.removeAll()
                self.searchPage = 1
                self.shouldShowEmptySearchView = false
                if self.searchText.isNotEmpty {
                    self.searchProductList()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchPoductList(categoryId : String) {
        if Connectivity.isConnectedToInternet {
            if self.page == 1 {
                self.productList.removeAll()
            }
            self.isLoading = true
            apiClient.APIRequest(router: .productList(categoryId: categoryId, page: self.page, keyword: TextResource.empty),
                                 responseType: ProductListModel.self)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self?.isLoading = false
                    }
                } receiveValue: { [weak self] response in
                    self?.isLoading = false
                    if let products = response.result{
                        if products.products.count > 0 {
                            self?.productList.append(contentsOf: products.products)
                            self?.hasNext = products.hasNext
                            self?.shouldShowEmptyView = false
                        }
                        else {
                            self?.shouldShowEmptyView = true
                        }
                        print("Api Hittting --->>>")
                    }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func updatePoductList(categoryId : String) {
        apiClient.APIRequest(router: .productList(categoryId: categoryId,page: self.page, keyword: TextResource.empty), responseType: ProductListModel.self)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { response in
                if let products = response.result{
                    self.productList = products.products
                }
            }
            .store(in: &cancellables)
    }
    func getProductImage(product : Product) ->  String {
        let images = product.variants.first
        let productImage = images?.productImage1 ??  ""
        return productImage
    }
    func getNonDiscountPrice() -> Int {
        return Int(self.selectedVariant?.nonDiscountPrice ?? 0)
    }
    @MainActor
    func postToCart(productId : String, varaintId : String,quantity : Int) async {
        if Connectivity.isConnectedToInternet {
            let params : [String : Any] = [
                ApiParameters.productId : productId,
                ApiParameters.productVariantId : varaintId,
                ApiParameters.quantity : quantity
            ]
            self.isLoading = true
            apiClient.APIRequest(router: .addTocat, parameters: params, responseType: AddToCartModel.self)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self?.isLoading = false
                    }
                } receiveValue: { response in
                    if let result = response.result {
                        self.isLoading = false
                        let cartCount = result.cart?.count
                        EventHandler.cartCountSubject.send(cartCount ?? 0)
                        ToastCenter.shared.showToast(TextResource.addedToCartAlert,type: .success)
                    }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func addToFavorite(productId : String,variantId : String,completion : @escaping (Bool) -> ()) {
        let param : [String : Any] = [ApiParameters.id : productId,
                                      ApiParameters.favoriteItem: FavoriteType.product.rawValue,ApiParameters.variantId: variantId]
        if Connectivity.isConnectedToInternet {
            self.shouldShowLoader = true
            apiClient.APIRequest(router: .addToFavorite, parameters: param, responseType: SimpleResponse.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.shouldShowLoader = false
                    ToastCenter.shared.showToast(error.backendError?.message ?? error.localizedDescription, type: .error)
                        break
                    }
                } receiveValue: { response in
                    self.shouldShowLoader = false
                    ToastCenter.shared.showToast(TextResource.addedTofavorite,type: .success)
                    completion(true)
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet)
        }
    }
    func deleteProductFromFavorites(productId : String,variantId : String,
                                    completion : @escaping (Bool) -> ()) {
        if Connectivity.isConnectedToInternet {
            shouldShowLoader = true
             
            let param : [String : Any] = [ApiParameters.id : productId,ApiParameters.variantId: variantId,ApiParameters.favoriteItem : FavoriteType.product.rawValue]
            apiClient.APIRequest(router: .deleteFavorite, parameters: param, responseType: SimpleResponse.self)
                .sink { completion in
                    switch  completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.shouldShowLoader = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? error.localizedDescription, type: .error)
                        break
                        
                    }
                } receiveValue: { response in
                    self.shouldShowLoader = false
                    ToastCenter.shared.showToast(response.message ?? TextResource.deleteFromFavoriteSuccessMessage,type: .success)
                    completion(true)
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func searchProductList() {
        if Connectivity.isConnectedToInternet {
                isLoading = true
            apiClient.APIRequest(router: .productList(categoryId: categoryId, page: self.searchPage, keyword: self.searchText),
                                 responseType: ProductListModel.self)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self?.isLoading = false
                        self?.shouldSearch = false
                    }
                } receiveValue: { response in
                    if let products = response.result{
                        self.filteredProductList.append(contentsOf: products.products)
                        self.searchHasNext = products.hasNext
                    }
                    
                    if self.filteredProductList.isEmpty {
                        self.shouldShowEmptySearchView = true
                    }
                    self.isLoading = false
                    self.shouldSearch = false
                   
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    @MainActor
    func updateProductCart(action: CartAction, productId: String,
                           productVariantId: String, forceAddToCart: Bool) async throws {
        isLoading = true
        defer { isLoading = false }

        let result = try await productCartUseCase.execute(
            action: action,
            productId: productId,
            productVariantId: productVariantId,
            forceAddToCart: forceAddToCart,
            cartId: ""
        )

        switch result {
        case .blocked(let message):
            alertMessage = message ?? ""
            self.selectedProductIdentiy = ProductIdentity(productId: productId, variantId: productVariantId, isInCart: false, cartQuantity: 0)
            showAlert = true

        case .updated(let variant, _, let cartCount, let isNew):
            selectedVariant = variant
            EventHandler.cartCountSubject.send(cartCount)
            if isNew {
                ToastCenter.shared.showToast(TextResource.addedToCartAlert, type: .success)
            }

        case .removed(let cartCount):
            EventHandler.cartCountSubject.send(cartCount)
        }
    }

    func fetchCartDetails() async {
        if UserSessionManager.shared.productIdententiyArray.isEmpty {
            do {
                guard let cartDetailUseCase else {
                    return
                }
                _ = try await cartDetailUseCase.execute()
            }
            catch {
                
            }
        }
    }
}

