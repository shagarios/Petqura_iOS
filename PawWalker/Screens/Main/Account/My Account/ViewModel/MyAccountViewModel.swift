//
//  MyAccountViewModel.swift
//  PawWalker
//
//  Created by shagar on 06/02/25.
//

import SwiftUI
import Combine

class MyAccountViewModel : ObservableObject {
    @Published var navigateToMyAppoiments : Bool = false
    @Published var navigateToMyOrders : Bool = false
    @Published var navigateToMyAddress : Bool = false
    @Published var navigateToNewAddress : Bool = false
    @Published var myAddress : Address?
    @Published var myAppointmentData : MyAppointments?
    @Injected var apiClient : ApiClientProtocol
    @Published var myOrder: MyOrder?
    @Published var addressCount : Int = 0
    @Published var appoinmentCount : Int = 0
    @Published var orderCount : Int = 0
    @Published var isLoading: Bool = false
    @Injected var coreDataService : CoreDataServiceProtocol
    @Injected var network : NetworkMonitor
    @Published var showDeleteAccountAlert : Bool = false
    @Published var loginRequiredAlert : Bool = false
    @Published var showMapScreen: Bool = false
    @Published var showLoginRequiredAlert: Bool = false
    @Published var showAlertMakePrimary : Bool = false
    @Published var showCart : Bool = false
    var cartDetailUseCase : CartDetailsUsecase
    var cancellable = Set<AnyCancellable>()
    init(cartDetailUseCase : CartDetailsUsecase) {
       // getAppointmentData()
        self.cartDetailUseCase = cartDetailUseCase
    }
    func getAddressList() {
        if Connectivity.isConnectedToInternet {
            apiClient.APIRequest(router: .getAddress,
                                 responseType: MyAdressListModel.self).sink {  completion in
                switch completion {
                case .finished:
                    break
                case .failure(_):
                    break
                }
            } receiveValue: { [weak self] response in
                if let list = response.result {
                    if list.count > 0 {
                        let address = list.filter({$0.defaultAddress == true})
                        if address.isEmpty {
                            self?.myAddress = list.last
                        }
                        else {
                            self?.myAddress = address.first
                        }
                    }
                    self?.addressCount = list.count
                }
                else {
                    self?.myAddress = nil
                }
            }
            .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet)
        }
    }
    func getAppointments() {
        if Connectivity.isConnectedToInternet {
            self.isLoading = true
            apiClient.APIRequest(router: .myAppointments(page: 1), responseType: MyAppointmentModel.self)
                .sink { [weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(_):
                        self?.isLoading = false
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    self.myAppointmentData = response.result?.appointments.first
                    self.appoinmentCount = response.result?.appointments.count ?? 0
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet)
        }
    }
    func fetchMyordersList() {
        if Connectivity.isConnectedToInternet {
            self.isLoading = true
            apiClient.APIRequest(router: .myOrders, responseType: MyOrdersModel.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isLoading = false
                        break
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    if let result = response.result {
                        self.myOrder = result.orders.first
                        self.orderCount = result.orders.count
                    }
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet)
        }
    }
    func logout() {
        if network.isConnectedToInternet {
            self.isLoading = true
            let param: [String: Any] = [ApiParameters.accessToken: UserSessionManager.shared.accessToken,
                                        ApiParameters.refreshToken: UserSessionManager.shared.refreshToken]
            apiClient.APIRequest(router: .logout, parameters: param, responseType: SimpleResponse.self)
                .sink { completion in
                    switch completion {
                    case.finished:
                        break
                    case .failure(let error):
                        self.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError, type: .error)
                    }
                } receiveValue: {[weak self] response in
                    guard let self = self else {return}
                    self.isLoading = false
                    clearUserData()
                    
                }
                .store(in: &cancellable)
        }
    }
    func deleteAccount() {
        self.isLoading = true
        apiClient.APIRequest(router: .delete, responseType: SimpleResponse.self)
            .sink { completion in
                switch completion {
                case.finished:
                    break
                case .failure(let error):
                    self.isLoading = false
                    ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError, type: .error)
                }
            } receiveValue: {[weak self] response in
                guard let self = self else {return}
                self.isLoading = false
                clearUserData()
            }
            .store(in: &cancellable)
    }
    func clearUserData() {
        let context = coreDataService.context
        if let user = self.fetchUser()  {
            context.delete(user)
            do {
                try context.save()
            }
            catch {
                print("issue is there")
            }
        }
        UserSessionManager.shared.user = nil
        
        UserSessionManager.shared.accessToken = ""
        UserSessionManager.shared.productIdententiyArray.removeAll()
        EventHandler.cartCountSubject.send(0)
        self.appoinmentCount = 0
        self.myAppointmentData = nil
        self.addressCount = 0
        self.myAddress = nil
        self.myOrder = nil
        self.orderCount = 0
        
    }
    func fetchUser() -> User? {
        let result:Result<[User],Error> = coreDataService.fetch(tableName: TableNames.user,
            sort: nil, predicate: nil, limit: nil)
        switch result {
        case .success(let users):
            return users.first
        case .failure(_):
            return nil
        }
    }
    func checkIfMapIsShowed()  {
        if UserSessionManager.shared.accessToken.isNotEmpty {
            let mapShowed  = UserDefaults.standard.bool(forKey: UserDefaultConstants.mapShowed.rawValue)
            if mapShowed == false {
                self.showMapScreen = true
            }
        }
    }
    func fetchCartDetails() async {
        if UserSessionManager.shared.productIdententiyArray.isEmpty {
            do {
                let cartResult = try await cartDetailUseCase.execute()
                let count = cartResult.cart?.count ?? 0
                EventHandler.cartCountSubject.send(count)
            }
            catch {
                
            }
        }
    }
}



enum UserDefaultConstants : String {
    case mapShowed = "MapShowed"

}
