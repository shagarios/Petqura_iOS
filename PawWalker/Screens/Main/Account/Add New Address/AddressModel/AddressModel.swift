//
//  AddressModel.swift
//  PawWalker
//
//  Created by shagar on 01/03/25.
//

struct AddressModel : Codable {
    let message : String
    let result : Address?
}


struct Address : Codable, Hashable {
    let address, addressType, addressUse, city: String?
    let defaultAddress: Bool?
    let email, fullname: String?
    let id: String?
    let phone, pin, state, user: String?
    let landmark: String?
    let userID: String?
    let latitude: Double?
    let longitude : Double?
    enum CodingKeys: String, CodingKey {
            case address
            case addressType = "address_type"
            case addressUse = "address_use"
            case city
            case defaultAddress = "default_address"
            case email, fullname
            case id
            case landmark, phone, pin, state, user
            case userID = "user_id"
            case latitude
            case longitude
        }
    
}
