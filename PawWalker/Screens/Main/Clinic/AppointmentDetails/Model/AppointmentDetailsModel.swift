//
//  AppointmentDetails.swift
//  PawWalker
//
//  Created by shagar on 05/02/25.
//

import Foundation

struct ClinicPaymentOrder : Codable {
    let response : ProductOrder
}

struct AppointmentChargeModel : Codable {
    let response : AppointmentChargeResponse
}

struct AppointmentChargeResponse : Codable {
    let couponPrice : Double?
    let gst : Double?
    let serviceFees : Double?
    let slotPrice : Double?
    let total : Double?
    let couponId : String?
    enum CodingKeys : String,CodingKey {
        case couponPrice = "coupon_price"
        case gst
        case  serviceFees = "service_fee"
        case slotPrice = "slot_price"
        case total
        case couponId = "coupon_id"
    }
}

struct AppointmentResponse: Codable {
    let message: String
    let result: AppointmentResult
}
struct AppointmentResult: Codable {
    let active: Bool
    let appointmentDate: String
    let appointmentId: String
    let clinicDetails: ClinicDetails
    let clinicId: String
    let doctorDescription: String?
    let doctorName: String?
    let doctorPhoto: String?
    let doctorQualifications: String?
    let doctorRequired: Bool?
    let endTime: String?
    let gst: String?
    let paymentDetails: PaymentDetails?
    let paymentId: String?
    let petName: String?
    let serviceFee: String?
    let slotPrice: String?
    let startTime: String?
    let status: String?
    let total: String?
    let userDetails: UserDetails?
    let visited: Bool?

    enum CodingKeys: String, CodingKey {
        case active
        case appointmentDate = "appointment_date"
        case appointmentId = "appointment_id"
        case clinicDetails = "clinic_details"
        case clinicId = "clinic_id"
        case doctorDescription = "doctor_description"
        case doctorName = "doctor_name"
        case doctorPhoto = "doctor_photo"
        case doctorQualifications = "doctor_qualifications"
        case doctorRequired = "doctor_required"
        case endTime = "end_time"
        case gst
        case paymentDetails = "payment_details"
        case paymentId = "payment_id"
        case petName = "pet_name"
        case serviceFee = "service_fee"
        case slotPrice = "slot_price"
        case startTime = "start_time"
        case status
        case total
        case userDetails = "user_details"
        case visited
    }
}

struct ClinicDetails: Codable {
    let active: Bool?
    let clinicAddressLine1: String?
    let clinicAddressLine2: String?
    let clinicCity: String?
    let clinicId: String?
    let clinicImage: String?
    let clinicName: String?
    let clinicPincode: String?
    let clinicState: String?
    let email: String?
    let phone: String?

    enum CodingKeys: String, CodingKey {
        case active
        case clinicAddressLine1 = "clinic_address_line_1"
        case clinicAddressLine2 = "clinic_address_line_2"
        case clinicCity = "clinic_city"
        case clinicId = "clinic_id"
        case clinicImage = "clinic_image"
        case clinicName = "clinic_name"
        case clinicPincode = "clinic_pincode"
        case clinicState = "clinic_state"
        case  email, phone
    }
}

struct PaymentDetails: Codable {
    let amount: String?
    let completedDate: String?
    let couponAmountUsed: String?
    let createdDate: String?
    let deliveryTip: Int?
    let gst: String?
    let guestId: String?
    let id: String?
    let isGuest: Bool?
    let paymentId: String?
    let paytmToken: String?
    let serviceFee: String?
    let status: String?
    let timeCreated: String?
    let timeUpdated: String?
    let userId: String?

    enum CodingKeys: String, CodingKey {
        case amount
        case completedDate = "completed_date"
        case couponAmountUsed = "coupon_amount_used"
        case createdDate = "created_date"
        case deliveryTip = "delivery_tip"
        case gst
        case guestId = "guest_id"
        case id
        case isGuest = "is_guest"
        case paymentId = "payment_id"
        case paytmToken = "paytm_token"
        case serviceFee = "service_fee"
        case status
        case timeCreated = "time_created"
        case timeUpdated = "time_updated"
        case userId = "user_id"
    }
}
struct UserDetails: Codable {
    let active: Bool?
    let email: String?
    let firstName: String?
    let id: String
    let phone: String?
    let whatsappNumber: String?

    enum CodingKeys: String, CodingKey {
        case active
        case email
        case firstName = "first_name"
        case id
        case phone
        case whatsappNumber = "whatsapp_number"
    }
}
