//
//  ProductDetailsViewModel.swift
//  PawWalker
//
//  Created by shagar on 23/01/25.
//

import SwiftUI
import Combine

class ProductDetailsViewModel  : ObservableObject {
    @Published var product : Product?
    @Published var showMore : Bool = false
    private var cancellables = Set<AnyCancellable>()
    @Published var reviewList : [ProductReview] = []
    @Published var showReviewPage : Bool = false
    @Published var showCartPage : Bool = false
    @Published var cartCount : Int = UserSessionManager.shared.cartItemCount
    @Published var showFullDescription : Bool = false
    @Published var navigateToDetailScreen : Bool = false
    @Published var selectedVariant : Variant?
    @Injected var apiClient : ApiClientProtocol
    @Published var productList : [Product] = []
    @Published var showReviewBottomSheet : Bool = false
    @Published var reviewText : String = TextResource.empty
    @Published var reviewRating : Int = 0
    @Published var averageRating : Double = 0
    @Published var isLoading : Bool = false
    @Published var moreProductList : [MoreProduct] = []
    @Injected var productCartUseCase : ProductCartUseCaseProtocol
    @Published var moreProductPageCount : Int = 1
    @Published var showMoreView : Bool = false
    var productMoreUseCase : ProductMoreUseCase
    @Published var showAlert : Bool = false
    @Published var selectedMoreProduct: MoreProduct?
    @Published var Quantity : Int = 0
    @Published var isInCart : Bool = false
    @Published var selectedProductIdentity : ProductIdentity?
    @Published var alertMessage : String = ""
    @Published var showAlertForCart : Bool = false
    private var productDetailUseCase : ProductDetailUseCase
    
    init(product : Product?,
         productMoreUseCase : ProductMoreUseCase,
         productDetailUseCase : ProductDetailUseCase) {
        self.product = product
        self.productMoreUseCase = productMoreUseCase
        self.productDetailUseCase = productDetailUseCase
        self.selectedVariant = self.product?.variants.first
        self.handleCartCountUpdate()
        
    }
    func handleCartCountUpdate() {
        EventHandler.cartCountSubject.sink { completion in
            switch completion {
            case .finished:
                break
            }
        } receiveValue: { count in
            self.cartCount = count
            
        }
        .store(in: &cancellables)
    }
    func getVariantList() -> [Variant] {
       return self.product?.variants ?? []
    }
    func getDiscountPrice() -> Int {
        return Int(selectedVariant?.discountedPrice ?? 0)
    }
    func fetchSimilarProducts()  {
        if Connectivity.isConnectedToInternet {
            apiClient.APIRequest(router: .similarProducts(seller: self.product?.addedByID ?? ""),
                                 responseType: ProductListModel.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        break
                    }
                } receiveValue: {[weak self] response in
                    if let products = response.result?.products {
                        self?.productList = products
                    }
                }
                .store(in: &cancellables)
        }
    }
    func fetchReviews()  {
        if Connectivity.isConnectedToInternet {
            apiClient.APIRequest(router: .productReview(productId: product?.productID ?? ""),
                                 responseType: ProductReviewModel.self)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { response in
                if let result = response.result {
                    self.reviewList = result.reviews
                    self.averageRating = result.averageRating ?? 0
                }
            }
            .store(in: &cancellables)
        }
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
                    self.isLoading = false
                    if let result = response.result {
                        guard let cartCount = result.cart?.count else {return}
                        EventHandler.cartCountSubject.send(cartCount)
                        ToastCenter.shared.showToast(TextResource.addedToCartAlert,type: .success)
                    }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func getNonDiscountPrice() -> Int {
        return Int(self.selectedVariant?.nonDiscountPrice ?? 0)
    }
    func addToFavorite(productId : String,variantId : String,completion : @escaping (Bool) -> ()) {
        let param : [String : Any] = [ApiParameters.id : productId,
                                      ApiParameters.favoriteItem: FavoriteType.product.rawValue,ApiParameters.variantId: variantId]
        if Connectivity.isConnectedToInternet {
            self.isLoading = true
            apiClient.APIRequest(router: .addToFavorite, parameters: param, responseType: SimpleResponse.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError,type: .error)
                        break
                    }
                } receiveValue: { response in
                    ToastCenter.shared.showToast(TextResource.addedTofavorite,type: .success)
                    completion(true)
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func deleteProductFromFavorites(productId : String,variantId : String,
                                    completion : @escaping (Bool) -> ()) {
        if Connectivity.isConnectedToInternet {
            self.isLoading = true
            let param : [String : Any] = [ApiParameters.id : productId,ApiParameters.variantId: variantId,ApiParameters.favoriteItem : FavoriteType.product.rawValue]
            apiClient.APIRequest(router: .deleteFavorite, parameters: param, responseType: SimpleResponse.self)
                .sink { completion in
                    switch  completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isLoading = false
                        break
                        
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    ToastCenter.shared.showToast(response.message ?? "successfully deleted from favorites",type: .success)
                    completion(true)
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func submitReviewToServer() {
        if Connectivity.isConnectedToInternet {
            var param : [String: Any] = [ApiParameters.pid : self.product?.productID ?? TextResource.empty]
            param[ApiParameters.reviewContent] = self.reviewText
            param[ApiParameters.reviewStarCount] = self.reviewRating
            self.isLoading = false
            apiClient.APIRequest(router: .addProductReview, parameters: param, responseType: SimpleResponse.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? "There is an error occured while adding review",type: .error)
                        break
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    Task {
                        await self.fetchReviews()
                    }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    @MainActor
    func fetchMoreProduct() async  {
        guard let productId = product?.productID,let variantId = selectedVariant?.productVariantID else {
            return
        }
        do {
            let response = try await
            productMoreUseCase.execute(productId: productId, variantId: variantId,
                                       page: moreProductPageCount,
                                       latitude: "", longtitude: "")
            self.moreProductList = response.result?.products ?? []
        }
        catch {
            
        }
    }
    func loadData()  {
         fetchSimilarProducts()
         fetchReviews()
        Task {
            await fetchMoreProduct()
        }
    }
    func updateData() {
        let variant =  UserSessionManager.shared.productIdententiyArray
            .filter({$0.variantId == selectedVariant?.productVariantID})
        if variant.isNotEmpty {
            selectedVariant?.isInCart = variant.first?.isInCart
            selectedVariant?.cartQuantity = variant.first?.cartQuantity
        }
    }
    @MainActor
    func updateProductCart(action: CartAction, productId: String,
                           productVariantId: String, forceAddToCart: Bool) async {
        isLoading = true
        defer { isLoading = false }
        do {
            let result = try await productCartUseCase.execute(
                action: action,
                productId: productId,
                productVariantId: productVariantId,
                forceAddToCart: forceAddToCart
            )
            switch result {
            case .blocked(let message):
                alertMessage = message ?? ""
                self.selectedProductIdentity = ProductIdentity(productId: productId,
                                                        variantId: productVariantId,
                                                               isInCart: false, cartQuantity: 0)
                showAlertForCart = true
            case .updated(let variant, _, let cartCount, let isNew):
                selectedVariant = variant
                EventHandler.cartCountSubject.send(cartCount)
                if isNew {
                    ToastCenter.shared.showToast(TextResource.addedToCartAlert, type: .success)
                }

            case .removed(let cartCount):
                EventHandler.cartCountSubject.send(cartCount)
                if cartCount == 0 {
                    self.selectedVariant?.isInCart = false
                    self.selectedVariant?.cartQuantity = 0
                }
            }
        }
        catch let error {
            print(error)
        }
    }
    @MainActor
    func fetchProductDetails(productId : String) async {
        do {
            self.isLoading = true
            let result = try await productDetailUseCase.execute(productId: productId)
            self.isLoading = false
            self.product = result
            await self.loadData()
        }
        catch {
        }
    }
}
