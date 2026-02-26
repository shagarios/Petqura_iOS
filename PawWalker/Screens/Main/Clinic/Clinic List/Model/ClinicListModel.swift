//
//  Untitled.swift
//  PawWalker
//
//  Created by shagar on 09/12/24.
//

struct ClinicListModel  : Codable {
    let message: String
    let result : ClinicListResult
}

struct ClinicListResult : Codable {
    var clinics: [Clinic]?
    let total: Int?
    let hasNext : Bool?
    enum CodingKeys : String,CodingKey {
        case clinics
        case total
        case hasNext = "has_next"
    }
}

struct Clinic : Codable,Hashable {
      let active: Bool
        let clinicAddressLine1, clinicAddressLine2, clinicCity, clinicID: String?
        let clinicImage: String?
        let clinicName, clinicPincode, clinicState: String?
        let email: String?
        let mid: String?
        let phone, serviceProviderID: String?
        let splitPercentage: Int?
        let userID: String
        let doctors: [Doctor]?
        let services: [Service]?
        var isfavorite : Bool?
    enum CodingKeys: String, CodingKey {
            case active
            case clinicAddressLine1 = "clinic_address_line_1"
            case clinicAddressLine2 = "clinic_address_line_2"
            case clinicCity = "clinic_city"
            case clinicID = "clinic_id"
            case clinicImage = "clinic_image"
            case clinicName = "clinic_name"
            case clinicPincode = "clinic_pincode"
            case clinicState = "clinic_state"
            case doctors, email, mid, phone
            case serviceProviderID = "service_provider_id"
            case services
            case splitPercentage = "split_percentage"
            case userID = "user_id"
            case isfavorite = "is_favourite"
        }
}


struct Doctor: Codable,Hashable {
    let active: Bool?
    let clinicID, description, doctorID, doctorName: String?
    let qualifications: String?
    let profilePhoto : String?
    enum CodingKeys: String, CodingKey {
        case active
        case clinicID = "clinic_id"
        case description
        case doctorID = "doctor_id"
        case doctorName = "doctor_name"
        case qualifications
        case profilePhoto = "profile_photo"
    }
}

struct Service: Codable,Hashable {
    let description, service : String?
    let serviceID: String
    let icon : String?
    enum CodingKeys: String, CodingKey {
        case description, service
        case serviceID = "service_id"
        case icon
    }
}
