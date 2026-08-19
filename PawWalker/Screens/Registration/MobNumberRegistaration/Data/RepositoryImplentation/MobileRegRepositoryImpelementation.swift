//
//  MobileRegistrationRepository.swift
//  PawWalker
//
//  Created by shagar on 09/07/26.
//
import Foundation
import Alamofire
class MobileRegRepositoryImplementation  : MobileRegRepository {
    @Injected var internet : NetworkMonitor
    @Injected var serviceLayer : ServiceLayerProtocol
    
    func registerMobileNumber(user : UserRegisterDetails) async throws -> MobileRegistrationModel {
        guard internet.isConnectedToInternet else {
            throw AppError.noInternet
        }
        let phoneNumber = ApiParameters.countryCode + user.phone
        var params : [String : String] = [ApiParameters.phone : phoneNumber, ApiParameters.source : ApiParameters.mobile]
        params[ApiParameters.firstName] = user.name.trimmed
        params[ApiParameters.email] = user.email
        do {
            return  try await serviceLayer.makeRequest(endpoint: .registerMobile,
                                                      parameters: params)
        }
        catch let error as NetworkError {
            if let backendError = error.backendError {
                 throw AppError.unknown(backendError.message)
             }
            else if let afError = error.initialError {
                 throw AppError(afError: afError)
             }
             else {
                 throw AppError.unknown(error.localizedDescription)
             }
         }
    }
}
