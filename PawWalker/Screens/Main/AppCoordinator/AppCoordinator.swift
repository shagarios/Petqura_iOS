//
//  AppCoordinator.swift
//  PawWalker
//
//  Created by shagar on 09/11/25.
//

import SwiftUI
import Combine

class AppCoordinator: ObservableObject {
    @Published var selectedTab: TabBarItems = .home // 0 = Deals, 1 = Clinic
    @Published var selectedServiceId : String = ""
    @Published var selectedCategoryId : String = ""
    @Published var navigateToClinicOrders : Bool = false
    @Published var navigateToAppointmentDetailsScreen : Bool = false
    @Published var navigateToSlotBookingScreen : Bool = false
    @Published var navigateToMyOrders : Bool = false
    @Published var flow : Flow = .dashboard
    @Injected var apiClient : ApiClientProtocol
    private var cancellable = Set<AnyCancellable>()
    @Published var appointmentId : String = ""
    @Published var cartItemCount : Int = 0
    @Published var selectedAccountPage : AccountPages = .myAccount
    @Published var selectedClinicId : String = ""
    @Published var serviceList : [Service] = []
    @Published var navigateToCart : Bool = false
    @Published var navigateTologin: Bool = false
    @Published var navigateToMyAddress : Bool = false
    init() {
        //self.flow = UserSessionManager.shared.isMapCompleted ? .dashboard : .auth
        self.flow = .dashboard
        handleCartCountUpdate()
        handleBrowseProduct()
        handleLoginNavigation()
        handleMyAddressNavigation()
        handleMyOrdersNavigation()
    }

    func handleCartCountUpdate() {
        EventHandler.cartCountSubject.sink { completion in
            switch completion {
            case .finished:
                break
            }
        } receiveValue: { count in
            DispatchQueue.main.async {
                self.cartItemCount = count
                UserSessionManager.shared.cartItemCount = count
            }
        }
        .store(in: &cancellable)
    }
    func handleBrowseProduct() {
        EventHandler.productListNavigationSubject.sink { completion in
            switch completion {
            case .finished:
                break
            }
        } receiveValue: { isNavigate in
            if isNavigate {
                self.selectedTab = .store
            }
        }
        .store(in: &cancellable)
    }
    func handleLoginNavigation() {
        EventHandler.loginNavigationSubject.sink { completion in
            switch completion {
            case .finished:
                break
            }
        } receiveValue: { _ in
            self.selectedTab = .account
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.navigateTologin = true
            })
        }
        .store(in: &cancellable)
        
    }
    func handleMyAddressNavigation() {
        EventHandler.MyAddressListNavigationSubject.sink { completion in
            switch completion {
            case .finished:
                break
            }
        } receiveValue: { _ in
            self.selectedTab = .account
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.navigateToMyAddress = true
            })
        }
        .store(in: &cancellable)
        
    }
    func handleMyOrdersNavigation() {
        EventHandler.myOrderNavigationSubject.sink { completion in
            switch completion {
            case .finished:
                break
            }
        } receiveValue: { _ in
            self.selectedTab = .account
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.navigateToMyOrders = true
            })
        }
        .store(in: &cancellable)
    }
    
    
    func fetchBasicInfo() async {
       await fetchCartCount()
    }
    @MainActor
    func fetchCartCount()  async {
        if Connectivity.isConnectedToInternet {
            apiClient.APIRequest(router: .viewCart(guestId: UserSessionManager.shared.guestId),
                                 responseType: AddToCartModel.self)
                .subscribe(on: DispatchQueue.global(qos: .background))
                .sink {  completion in
                    switch completion {
                    case .failure(_):
                        break
                    case .finished:
                        break
                    }
                } receiveValue: {  reponse in
                    if let result = reponse.result {
                        guard let count = result.cart?.count else {return}
                        EventHandler.cartCountSubject.send(count)
                    }
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func  titleView() -> some View {
        Image(ImageResource.homeLogo)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 120,height: 50)
    }
    func registrationCompleted() {
           flow = .dashboard
       }
    func showLoginScreen() {
        self.selectedTab = .account
    }
    
}

