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
    @Published var navigateToMyOrders : Bool = false
    @Published var flow : Flow = .dashboard
    @Injected var apiClient : ApiClientProtocol
    private var cancellable = Set<AnyCancellable>()
    @Published var appointmentId : String = ""
    @Published var cartItemCount : Int = 0
    @Published var selectedAccountPage : AccountPages = .myAccount
    init() {
        //self.flow = UserSessionManager.shared.isMapCompleted ? .dashboard : .auth
        self.flow = .dashboard
    }
    func handleCartCountUpdate() {
        EventHandler.cartCountSubject.sink { completion in
            switch completion {
            case .finished:
                break
            }
        } receiveValue: { count in
            self.cartItemCount = count
            UserSessionManager.shared.cartItemCount = count
        }
        .store(in: &cancellable)
    }
    func fetchBasicInfo() async {
       await fetchCartCount()
    }
    func fetchCartCount()  async {
        if Connectivity.isConnectedToInternet {
            apiClient.APIRequest(router: .viewCart, responseType: AddToCartModel.self)
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
                        let  count = result.cart.count
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

