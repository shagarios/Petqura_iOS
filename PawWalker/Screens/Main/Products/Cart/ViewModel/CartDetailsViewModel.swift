//
//  CartViewModel.swift
//  PawWalker
//
//  Created by shagar on 10/02/25.
//

import Foundation
import Combine
import SwiftUI

class CartDetailsViewModel : ProductListViewModel {
    @Published var cartDetails : CartResult?
    @Published var cartList : [CartElement] = []
    private var cancellables = Set<AnyCancellable>()
    @Published var billData : [BillItem] = []
    @Published var cartCount : Int = 0
    @Published var navigateToAddressList : Bool = false
    @Published var myAddress : Address?
    @Published var tipValue : String = TextResource.empty
    @Published var customTip : Double = 0
    @Published var showDeliveryTipOtherView : Bool = false
    @Published var orderID : String = TextResource.empty
    @Published var sessionID : String = TextResource.empty
    @Published var showCashfreePage : Bool = false
    @Published var navigateToMyorders : Bool = false
    @Published var showFullBill : Bool = false
    @Published var isUseCoins : Bool = false
    @Published var loginRequiredAlert : Bool = false
    var cartAdditionUseCase : CartAdditionUseCase
    @Published var shouldDismiss: Bool = false
    @Published var addressList : [Address] = [] {
        didSet {
            if addressList.count > 0 {
                let address = self.addressList.filter({$0.defaultAddress == true})
                if address.isEmpty {
                    self.myAddress = addressList.last
                }
                else {
                    self.myAddress = address.first
                }
            }
        }
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
    @Published var deliveryTipList : [DeliveryTip] = [.tip10,.tip20,.tip30]
    @Published var deliveryTip : DeliveryTip = .tip0 {
        didSet {
            self.showDeliveryTipOtherView = self.deliveryTip == .other
            self.deliveryTipValue = self.deliveryTip.value
        }
    }
    @Published var deliveryTipValue : Double = 0
     init(cartAdditionUseCase : CartAdditionUseCase) {
         self.cartAdditionUseCase = cartAdditionUseCase
    super.init(cartDetailUseCase:
                CartDetailsUsecase(repository:
                                    CartRepositroyImplementation(),
                                    guestReposiotry: GuestSessionRepositoryImplementation(
                                    userSessionRespository: UserSessionRepostoryImplentation())))
        CashFreeBroker.cashFreeCompletion
            .sink { status in
                self.showCashfreePage = false
                if status {
                    EventHandler.cartCountSubject.send(0)
                    self.cartList.removeAll()
                    self.shouldDismiss = true
                    EventHandler.myOrderNavigationSubject.send()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
//                                  EventHandler.myOrderNavigationSubject.send()
//                              }
                }
            }
            .store(in: &cancellables)
    }
    

    
     func fetchCartList() {
        if Connectivity.isConnectedToInternet {
            isLoading = true
            apiClient.APIRequest(router: .viewCart(guestId: UserSessionManager.shared.guestId), responseType: AddToCartModel.self).sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    self.isLoading = false
                }
            } receiveValue: { [weak self] response in
                if let result = response.result {
                    self?.billData.removeAll()
                    self?.isLoading = true
                    self?.cartDetails = result
                    self?.cartList = result.cart ?? []
                    self?.cartCount = result.cart?.count ?? 0
                    EventHandler.cartCountSubject.send(self?.cartCount ?? 0)
                }
            }
            .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    @MainActor
    func fetchCart() async {
        do {
            isLoading = true
            let result = try await cartDetailUseCase?.execute()
            self.isLoading = false
            self.billData.removeAll()
            self.cartDetails = result
            self.cartList = result?.cart ?? []
            self.cartCount = result?.cart?.count ?? 0
            EventHandler.cartCountSubject.send(self.cartCount)
        }
        catch {
            self.isLoading = false
        }
        
    }
    func updateCartItem(action : CartAction,cartId : String) {
        if Connectivity.isConnectedToInternet {
            isLoading = true
            let param : [String : Any] = [ApiParameters.cartId : cartId, ApiParameters.action : action.rawValue]
            apiClient.APIRequest(router: .updateCart, parameters: param, responseType: AddToCartModel.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self.isLoading = false
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    if let result = response.result {
                        self.cartDetails = result
                        guard let cart = result.cart else {return}
                        self.cartList = cart
                        ToastCenter.shared.showToast(response.message,type: .success)
                        self.cartCount = cart.count
                        EventHandler.cartCountSubject.send(self.cartCount)
                    }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    
    func updateCartDetails(action : CartAction,cartId : String) async {
        do {
            self.isLoading = true
            let response : AddToCartModel = try await cartAdditionUseCase.execute(action: action,
                                                                                 productId: "",
                                                                                 productVariantId: "",
                                                                                 forceAddToCart: false,
                                                                                 cartId: cartId)
            self.isLoading = false
            if let result = response.result {
                self.cartDetails = result
                guard let cart = result.cart else {return}
                self.cartList = cart
                ToastCenter.shared.showToast(response.message,type: .success)
                self.cartCount = cart.count
                EventHandler.cartCountSubject.send(self.cartCount)
            }
           
           
        }
        catch let error as AppError {
            self.isLoading = false
            ToastCenter.shared.showToast(error.errorDescription ?? "Something went wrong",type: .error)
        }
        catch {
            self.isLoading = false
            ToastCenter.shared.showToast(error.localizedDescription,type: .error)
        }
    }
    
    func getAddressList() {
        if Connectivity.isConnectedToInternet {
            apiClient.APIRequest(router: .getAddress, responseType: MyAdressListModel.self)
                .sink { [weak self] completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { [weak self] response in
                if let result = response.result {
                    self?.addressList = result
                }
                else {
                    self?.addressList = []
                }
            }
            .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func deliveryTipColor(item : DeliveryTip) -> Color {
        return item == self.deliveryTip ? Color(ColorResource.primaryButton) : ColorContants.lightLittleGray
    }
    func totalPrice() -> String {
        let totalAmount = cartDetails?.orderTotalWithShipping ?? 0
        var totalPrice = totalAmount
        if isUseCoins {
            totalPrice = totalAmount - (self.cartDetails?.pointsRedeemable ?? 0) + self.deliveryTipValue
        }
        else {
            totalPrice = totalAmount + self.deliveryTipValue
        }
        return totalPrice.stringValue()
    }
    func productPayment() {
        if Connectivity.isConnectedToInternet {
            self.isLoading = false
            var param : [String : Any] = [ApiParameters.useCoins : isUseCoins]
            param[ApiParameters.addressID] = self.myAddress?.id ?? 0
            param[ApiParameters.tip] = Int(self.deliveryTipValue)
            apiClient.APIRequest(router: .productPayment, parameters: param, responseType: ProductOrderResponse.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError,type: .error)
                    }
                } receiveValue: { response in
                    ToastCenter.shared.showToast(TextResource.orderCreatedSuccessfully,type: .success)
                    self.orderID = response.response.orderID
                    self.sessionID = response.response.paymentSessionID
                    self.showCashfreePage = true
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func fetchSimilarProducts() {
        if Connectivity.isConnectedToInternet {
            apiClient.APIRequest(router: .productForYou,
                                 responseType: ProductListModel.self)
                .sink { [weak self] completion in
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
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }

}

enum CartAction : String {
    case add
    case less
}
enum DeliveryTip : String {
    case tip10
    case tip20
    case tip30
    case tip50
    case tip0
    case other
    
    var displayValue: String {
        switch self {
        case .tip10:
            return TextResource.tenRupees
        case .tip20:
            return TextResource.twentyRupees
        case .tip30:
            return TextResource.thirtyRupees
        case .tip50:
            return TextResource.fiftyRupees
        case .tip0:
            return TextResource.zeroRupees
        case .other:
            return TextResource.other
        }
    }
    var value : Double {
        switch self {
        case .tip10:
            return 10
        case .tip20:
            return 20
        case .tip30:
            return 30
        case .tip50:
            return 50
        case .tip0:
            return 0
        case .other:
            return 0
        }
    }
}
