//
//  NewAddressViewModel.swift
//  PawWalker
//
//  Created by shagar on 20/02/25.
//
import SwiftUI
import Combine

class NewAddressViewModel : ObservableObject {
    
    @Published var selectedAddressType : AddressType = .home
    @Published var fullName : String = TextResource.empty
    @Published var mobileNumber : String = TextResource.empty
    @Published var addressLine : String = TextResource.empty
    @Published var country : String = TextResource.empty
    @Published var city : String = TextResource.empty
    @Published var zipcode : String = TextResource.empty
    @Published var email : String = TextResource.empty
    @Published var state : String = TextResource.empty
    @Injected var apiClient : ApiClientProtocol
    @Published  var showAddressType : Bool = false
    @Published var addrressTypeList : [AddressType] = [.home,.work,.other]
    @Published var isEdit : Bool = false
    var cancellable = Set<AnyCancellable>()
    @Published var address : Address?
    @Published var isLoading: Bool = false
    
    init(isEdit : Bool, address: Address?) {
            if let addressDetails = address {
                self.fullName = addressDetails.fullname ?? TextResource.empty
                self.mobileNumber = addressDetails.phone  ?? TextResource.empty
                self.email = addressDetails.email  ?? TextResource.empty
                self.addressLine = addressDetails.address  ?? TextResource.empty
                self.state = addressDetails.state ?? TextResource.empty
                self.city = addressDetails.city ?? TextResource.empty
                self.country = "india"
                self.zipcode = addressDetails.pin ?? TextResource.empty
                self.address = addressDetails
             }
        
        self.isEdit = isEdit
    }
    
    func saveAddress(callBack : @escaping (Bool) -> ()) {
        if Connectivity.isConnectedToInternet {
            let param = getCommonParams()
            self.isLoading = true
            apiClient.APIRequest(router: .saveAddress, parameters: param, responseType: AddressModel.self)
                .sink { completion in
                    switch completion {
                    case .finished:
                        callBack(false)
                    case .failure(let error):
                        self.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? error.localizedDescription,type: .error)
                        callBack(false)
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    if let result = response.result {
                        ToastCenter.shared.showToast(response.message,type: .success)
                        callBack(true)
                    }
                    else {
                        callBack(false)
                    }
                    
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    
    func getCommonParams () -> [String : Any] {
        let param : [String : Any] = [ApiParameters.fullname : self.fullName,
                                      ApiParameters.address : self.addressLine,
                                      ApiParameters.pin : self.zipcode,
                                      ApiParameters.address_type : self.selectedAddressType.rawValue,
                                      ApiParameters.city : self.city,
                                      ApiParameters.phone : self.mobileNumber,
                                      ApiParameters.state : self.state,
                                      ApiParameters.email : self.email,
                                      ApiParameters.latitude: self.address?.latitude?.stringValue() ?? "",
                                      ApiParameters.longitude: self.address?.longitude?.stringValue() ?? ""
        ]
        return param
    }
    
    func editAddress(callBack : @escaping (Bool) -> ()) {
        if Connectivity.isConnectedToInternet {
            var param = getCommonParams()
            guard let id = self.address?.id else {return}
            param[ApiParameters.id] = id
            self.isLoading = true
            apiClient.APIRequest(router: .editAddress,parameters: param ,responseType: AddressModel.self)
                .sink {[weak self] completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self?.isLoading = false
                        ToastCenter.shared.showToast(error.backendError?.message ?? TextResource.apiError,type: .error)
                    }
                } receiveValue: { response in
                    self.isLoading = false
                    if let result = response.result {
                        ToastCenter.shared.showToast(response.message,type: .success)
                        callBack(true)
                    }
                    else {
                    
                        callBack(false)
                    }
                }
                .store(in: &cancellable)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func isMobileValid() -> Bool {
        return mobileNumber.count == 10
    }
    func isZipCodeValid() -> Bool {
        return zipcode.count == 6
    }
    func isEmailValid() -> Bool {
        Predicates.emailPredicate().evaluate(with: email)
    }
    func isAllFieildISValid() -> Bool {
        return fullName.isNotEmpty && addressLine.isNotEmpty && city.isNotEmpty && state.isNotEmpty && isMobileValid() && isZipCodeValid()
    }
    
    func handleSaveAddress(completion : @escaping(Bool) -> ()) {
        guard isMobileValid() else {
            ToastCenter.shared.showToast(TextResource.mobileNumberNotValidText,type: .error)
               return
           }

           guard isZipCodeValid() else {
               ToastCenter.shared.showToast(TextResource.enterValidZipCode,type: .error)
               return
           }

        guard isAllFieildISValid() else {
            ToastCenter.shared.showToast(TextResource.validationTextForAllFields,type: .error)
               return
           }

           saveAddress { status in
               completion(status)
           }
    }
}



