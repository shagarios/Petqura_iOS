//
//  Model.swift
//  PawWalker
//
//  Created by shagar on 29/01/25.
//

struct DateItem  : Equatable {
    let label : String
    let date : String
    let actualDate : String
}

struct SlotListingModel : Codable {
    let message : String
    let result : SlotListingResult
}

struct SlotListingResult : Codable {
    let clinic : Clinic?
    let slots : [SlotList]
}

struct SlotList: Codable {
    let doctorFee, doctorID, doctorName: String?
    let slotCount, slotUnavailablecount: Int?
    let description : String?
    let qualifications : String?
    let profilePhoto : String?
    let slots: [Slot]
    enum CodingKeys: String, CodingKey {
        case doctorFee = "doctor_fee"
        case doctorID = "doctor_id"
        case doctorName = "doctor_name"
        case slotCount = "slot_count"
        case slotUnavailablecount = "slot_unavailablecount"
        case slots
        case description
        case qualifications
        case profilePhoto = "profile_photo"
    }
}

struct Slot : Codable, Hashable {
    let active: String?
    let slotID: String
    let time: String
    enum CodingKeys: String, CodingKey {
        case active
        case slotID = "slot_id"
        case time
    }
}

struct ClinicData: Hashable {
    var clinicName : String
    var image : String
    var address : String
    var phoneNumber : String
    var email : String
    var clinicId : String
}

struct AppointmentData : Hashable{
    var date : String
    var time : String
    var slotId : String
}

struct DocterData: Hashable {
    var docterName : String
    var image: String
    var qualification : String
    var price : String
    var description : String
    var profilePhoto : String
}

//typealias ClinicData = (clinicName : String,image : String,address : String,phoneNumber : String,email : String)
//
//typealias AppointmentData = (date : String,time : String)
//
//typealias DocterData =  (docterName : String,image: String,qualification : String,price : String)
