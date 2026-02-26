//
//  Otp.swift
//  PawWalker
//
//  Created by shagar on 04/12/24.
//

struct OtpModel : Codable {
    let message : String
    let result : OtpResult?
}
struct OtpResult: Codable {
    let accessToken, refreshToken: String
    let user: UserData?
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case user
    }
}
struct UserData: Codable {
    let phone : String?
    let firstName : String?
    let email: String?
    enum CodingKeys : String,CodingKey {
        case phone
        case firstName = "first_name"
        case email
    }
}
