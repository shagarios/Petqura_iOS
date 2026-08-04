//
//  MobileRegRepository.swift
//  PawWalker
//
//  Created by shagar on 09/07/26.
//

import Foundation

protocol MobileRegRepository  {
    func registerMobileNumber(user : UserRegisterDetails) async throws -> MobileRegistrationModel
}
