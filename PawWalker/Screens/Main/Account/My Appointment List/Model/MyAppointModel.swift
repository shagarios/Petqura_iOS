//
//  MyAppointModel.swift
//  PawWalker
//
//  Created by shagar on 23/03/25.
//

struct MyAppointmentData {
    let id : Int
    let petName : String
    let docterName : String
    let clinicName : String
    let time : String
    let date : String
}

struct MyAppointmentModel : Codable {
    let message : String
    let result : MyAppointmentResult?
}

struct MyAppointmentResult : Codable {
    let appointments : [MyAppointments]
}

struct MyAppointments : Codable {
    let active : Bool
    let date : String?
    let doctor : String?
    let startTime : String?
    let docterName : String?
    let endTime : String?
    let petName : String?
    let status : String?
    let appointmentId : String
    let clinicDetails : ClinicAppointment?
    let clinicService: String?
    enum CodingKeys: String,CodingKey {
        case active
        case date = "appointment_date"
        case doctor
        case startTime = "start_time"
        case endTime = "end_time"
        case clinicDetails = "clinic_details"
        case petName =  "pet_name"
        case appointmentId  = "appointment_id"
        case status
        case clinicService = "clinic_service"
        case docterName = "doctor_name"
    }
}

struct ClinicAppointment : Codable {
    let clinicName : String
    enum CodingKeys: String,CodingKey {
        case clinicName = "clinic_name"
    }
}
