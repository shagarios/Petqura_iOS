//
//  MobileRegistrationRepository.swift
//  PawWalker
//
//  Created by shagar on 09/07/26.
//
import Foundation
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
        return try await serviceLayer.makeRequest(endpoint: .registerMobile,
                                                  parameters: params)
    }
}
