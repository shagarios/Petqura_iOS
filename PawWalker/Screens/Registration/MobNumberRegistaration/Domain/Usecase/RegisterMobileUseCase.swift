//
//  RegisterMobileUseCase.swift
//  PawWalker
//
//  Created by shagar on 09/07/26.
//

import Foundation

class RegisterMobileUseCase {
    let registerRepostory : MobileRegRepository
    init(registerRepostory: MobileRegRepository) {
        self.registerRepostory = registerRepostory
    }
    func execute(user : UserRegisterDetails) async throws -> MobileRegistrationModel {
        do {
            let response : MobileRegistrationModel  = try await registerRepostory.registerMobileNumber(user: user)
            return response
        }
        catch let error as RequestError {
           throw AppError(requestError: error)
        }
    }
}
