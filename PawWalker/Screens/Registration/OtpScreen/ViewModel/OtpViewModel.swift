//
//  OtpViewModel.swift
//  PawWalker
//
//  Created by shagar on 13/11/24.
//

import SwiftUI
import Combine

class OtpViewModel : ObservableObject {
    @Published var navigateToMap : Bool = false
    @Injected var apiClient : ApiClientProtocol
    @Injected var coredataService : CoreDataServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    var cancellable = Set<AnyCancellable>()
    @Published var otp : String = TextResource.empty {
        didSet {
            if otp.count == 4 {
                isOtpValidated = true
            }
            else {
                isOtpValidated = false
            }
        }
    }
    @Published var isOtpValidated : Bool = false
    @Published var mobileNumber : String = TextResource.empty
    @Published var isLoading : Bool = false
    @Published var firstName : String = TextResource.empty
    @Published var email : String = TextResource.empty
    weak var coordinator : AccountCoordinator?
    var guestSessionRepository : GuestSessionRepository
    init(mobileNumber : String,coordinator : AccountCoordinator,
         firstName: String,email: String,
         guestSessionRepository : GuestSessionRepository) {
        self.mobileNumber = mobileNumber
        self.coordinator = coordinator
        self.email = email
        self.firstName = firstName
        self.guestSessionRepository = guestSessionRepository
    }
    func verifyOtp() {
        if isOtpValidated {
            requestToVerifyOtp()
        }
        else {
            ToastCenter.shared.showToast("OTP is not Valid",type: .error)
        }
    }
    func requestToVerifyOtp() {
        if Connectivity.isConnectedToInternet {
            let phoneNumber = TextResource.defaultCountryCode + mobileNumber
            var param : [String : Any] = [ApiParameters.otp : otp, ApiParameters.phone : phoneNumber]
            param[ApiParameters.deviceToken] = UserSessionManager.shared.deviceToken
            param[ApiParameters.deviceType] = "ios"
            param[ApiParameters.device_id] = UIDevice.current.identifierForVendor!.uuidString
            if UserSessionManager.shared.guestId.isNotEmpty {
            param[ApiParameters.guestId] = UserSessionManager.shared.guestId
            }
            isLoading = true
            apiClient.APIRequest(router: .verifyOtp, parameters: param, responseType: OtpModel.self)
                .sink { response in
                    switch response {
                    case .finished:
                        break
                    case .failure(let error):
                        self.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError,type: .error)
                    }
                } receiveValue: {[weak self] response in
                    guard let self = self else {return}
                    if let result = response.result {
                        self.saveUserDetailsToLocalStorage(result: result)
                        self.guestSessionRepository.deleteGuestId()
                        EventHandler.cartCountSubject.send(0)
                        UserSessionManager.shared.productIdententiyArray.removeAll()
                        if  let location = getLocationData() {
                            saveLocationToServer(location: location) {
                                self.coordinator?.popToRoot()
                            }
                        }
                        else {
                            self.coordinator?.popToRoot()
                        }
                    }
                    else {
                        ToastCenter.shared.showToast(TextResource.apiError,type: .error)
                    }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    
    func saveUserDetailsToLocalStorage(result : OtpResult) {
        let entity : Any? = fetchUser() ?? coredataService.createEntity(for: TableNames.user)
        guard let newUser = entity as? User else {return}
        newUser.accessToken = result.accessToken
        newUser.refreshToken = result.refreshToken
        newUser.mobileNumber = mobileNumber
        newUser.name = firstName
        newUser.email = email
        newUser.isMapCompleted = false
        coredataService.save(object: newUser)
            UserSessionManager.shared.name = firstName
        UserSessionManager.shared.user = newUser
    }
    func fetchUser() -> User? {
        let result: Result<[User],Error> = coredataService.fetch(tableName: TableNames.user, sort: nil, predicate: nil, limit: 0)
        switch result {
        case .success(let users):
            return users.first
        case .failure(_):
            return nil
        }
    }
    func registerWithMobileNumber() {
        if Connectivity.isConnectedToInternet {
            let phoneNumber = ApiParameters.countryCode + mobileNumber
            var params : [String : String] = [ApiParameters.phone : phoneNumber, ApiParameters.source : ApiParameters.mobile]
            params[ApiParameters.firstName] = self.firstName
            params[ApiParameters.email] = self.email
            print(params)
            self.isLoading = true
            apiClient.APIRequest(router: .registerMobile, parameters: params, responseType: MobileRegistrationModel.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        self.isLoading = false
                    case .failure(let error):
                        ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError,type: .error)
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    ToastCenter.shared.showToast(response.message,type: .success)
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func saveLocationToServer(location:LocationData,onComplete: @escaping () -> ()) {
        if Connectivity.isConnectedToInternet {
            var param : [String : Any] = [ApiParameters.latitude : location.latitude ?? "",
                                          ApiParameters.longitude : location.longitude ?? ""]
            param[ApiParameters.locality] = location.locality ?? ""
            param[ApiParameters.administrativeArea] = location.administativeArea ?? ""
            param[ApiParameters.country] = location.country ?? ""
            param[ApiParameters.subLocality] = location.subLocality ?? ""
            param[ApiParameters.postalCode] = location.postalCode ?? ""
            var address : [String] = []
            getAdress().forEach { adressDB in
                address.append(adressDB.name ?? "")
            }
            param[ApiParameters.address] = address
            print(param)
            apiClient.APIRequest(router: .location, parameters: param, responseType: SimpleResponse.self)
                .sink {[weak self] completion in
                    switch completion {
                    case .finished:
                        self?.isLoading = false
                    case .failure(let error):
                        self?.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError,type: .error)
                        onComplete()
                    }
                } receiveValue: {[weak self] response in
                    guard let self = self else {return}
                    self.isLoading = false
                    if let _ = response.message {
                        UserSessionManager.shared.isMapCompleted = true
                    }
                    onComplete()
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func getLocationData() -> LocationData? {
        let result : Result<[LocationData],Error> = coredataService.fetch(tableName: TableNames.locationData, sort: nil, predicate: nil, limit: 0)
        switch result {
        case .success(let location):
            return location.first
        case .failure(_):
            return nil
        }
    }
    func getAdress() -> [AddressDB] {
        let result : Result<[AddressDB],Error> = coredataService.fetch(tableName: TableNames.address, sort: nil, predicate: nil, limit: 0)
        switch result {
        case .success(let address):
            return address
        case .failure(_):
            return []
        }
    }
}
