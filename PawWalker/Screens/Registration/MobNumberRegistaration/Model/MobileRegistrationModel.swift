//
//  MobileRegistrationModel.swift
//  PawWalker
//
//  Created by shagar on 02/12/24.
//

struct MobileRegistrationModel : Codable {
    let message : String
    let result : MobileResistrationResult?
}

struct MobileResistrationResult : Codable {
    let active: Bool?
    let phone : String?
}
