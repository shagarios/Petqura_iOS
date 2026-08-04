//
//  MobileNumberRegistrationViewModel.swift
//  PawWalker
//
//  Created by shagar on 09/11/24.
//

import Foundation
import ProgressHUD
import Combine

class MobileNumberRegistrationViewModel : ObservableObject,ErrorHandable {
    @Injected var encryptionService : EncryptionManagerProtocol
    @Injected var apiClient : ApiClientProtocol
    @Published var mobileNumber : String = TextResource.empty
    @Published var name : String = TextResource.empty
    @Published var email : String = TextResource.empty
    private var cancellables = Set<AnyCancellable>()
    @Published var isLoading: Bool = false
    let key = "MduiQTgMNZCWUY,VhnmM2cKXDLVFvHFo"
    weak var coordinator : AccountCoordinator?
    var registerUserCase : RegisterMobileUseCase
    init(coordinator : AccountCoordinator,registerUserCase : RegisterMobileUseCase) {
        self.coordinator = coordinator
        self.registerUserCase = registerUserCase
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
    @MainActor
    func registerMobileNumber() async {
        let userDetails = UserRegisterDetails(name: name.trimmed,
                                              phone: mobileNumber, email: email)
        self.isLoading = true
        do {
            let response = try await registerUserCase.execute(user: userDetails)
            self.isLoading = false
            ToastCenter.shared.showToast(response.message,type: .success)
            self.coordinator?.push(.otp(mobileNo: self.mobileNumber,
                                        firstName: self.name,email: self.email))
        }
        catch let error as AppError {
            self.isLoading = false
            showError(error.errorDescription)
        }
        catch {
            self.isLoading = false
            showError(TextResource.apiError)
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
            Task {
                await registerMobileNumber()
            }
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
