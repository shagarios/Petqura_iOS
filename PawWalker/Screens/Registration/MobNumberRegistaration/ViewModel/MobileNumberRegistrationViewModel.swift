//
//  MobileNumberRegistrationViewModel.swift
//  PawWalker
//
//  Created by shagar on 09/11/24.
//

import Foundation
import ProgressHUD
import Combine

class MobileNumberRegistrationViewModel : ObservableObject {
    @Injected var encryptionService : EncryptionManagerProtocol
    @Injected var apiClient : ApiClientProtocol
    @Published var mobileNumber : String = TextResource.empty
    @Published var name : String = TextResource.empty
    @Published var email : String = TextResource.empty
    private var cancellables = Set<AnyCancellable>()
    @Published var isLoading: Bool = false
    let key = "MduiQTgMNZCWUY,VhnmM2cKXDLVFvHFo"
    weak var coordinator : AccountCoordinator?
    init(coordinator : AccountCoordinator) {
        self.coordinator = coordinator
    }
    func checkprogressHud() {
        ToastCenter.shared.showToast("Please enter mobile number",type: .error)
    }
    func getEncriptedData() {
        guard let enriptedData  = encryptionService.encrypt(key: key, value: "+918289973873") else {
            print("error occured")
            return
        }
        
    }
    func registerWithMobileNumber() {
        if Connectivity.isConnectedToInternet {
            let phoneNumber = ApiParameters.countryCode + mobileNumber
            var params : [String : String] = [ApiParameters.phone : phoneNumber, ApiParameters.source : ApiParameters.mobile]
            params[ApiParameters.firstName] = self.name.trimmingCharacters(in: .whitespacesAndNewlines)
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
                    //  if let phoneNumber = response.result?.phone {
                        ToastCenter.shared.showToast(response.message,type: .success)
                    self.coordinator?.push(.otp(mobileNo: self.mobileNumber,
                                                firstName: self.name,email: self.email))
                    
                    //   }
                }
                .store(in: &cancellables)
        }
        else {
            ToastCenter.shared.showToast(TextResource.noInternet,type: .error)
        }
    }
    func isValidMobileNumber(number : String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", RegexStrings.mobileNumberValidation)
        return predicate.evaluate(with: number)
    }
    func isValidName(name : String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", RegexStrings.nameValidation)
        return predicate.evaluate(with: name)
    }
    func isEmailValid() -> Bool {
        Predicates.emailPredicate().evaluate(with: self.email)
    }
    func handleMobileNumberValidation() {
        if isValidMobileNumber(number: self.mobileNumber) &&
            isValidName(name: self.name) && isEmailValid(){
            registerWithMobileNumber()
        }
        else if isValidName(name: self.name) == false {
            ToastCenter.shared.showToast(TextResource.nameNotValidText)
        }
        else if isValidMobileNumber(number: self.mobileNumber) == false {
            ToastCenter.shared.showToast(TextResource.mobileNumberNotValidText)
        }
        else {
            ToastCenter.shared.showToast(TextResource.emailValidationText)
        }
    }
}
