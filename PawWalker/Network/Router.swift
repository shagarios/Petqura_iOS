//
//  ApiEndPoint.swift
//  PawWalker
//
//  Created by shagar p k on 11/09/24.
//

import Foundation
import Alamofire

enum Router {
    case getPost
    case registerMobile
    case verifyOtp
    case clinicList(serviceId : String,page : Int,keyword : String,latitude: String = "",longitude: String = "")
    case productList(categoryId : String,page : Int,keyword : String)
    case slotListing(clinicId: String, day : String,time : String)
    case addTocat
    case home
    case viewCart
    case updateCart
    case location
    case saveAddress
    case getAddress
    case deleteAddress(id : String)
    case editAddress
    case tokenRefresh
    case productPayment
    case myOrders
    case addToFavorite
    case getProductFavorite
    case getClinicFavorite
    case deleteFavorite
    case clinicPayment
    case myAppointments
    case similarProducts(seller : String)
    case productForYou
    case productReview(productId : String)
    case clinicReview(clinicId : String)
    case blogList
    case blogDetail(blogId : String)
    case addProductReview
    case addClinicReview
    case appointmentCharge
    case logout
    case delete
    case getAppointmentDetails(appointmentId : String)
    case clinicFilters
    private var baseUrl:  String {
        return Bundle.main.apiBaseUrl
    }
    
    var path : String {
        switch self {
        case .getPost:
            return "https://jsonplaceholder.typicode.com/posts"
        case .registerMobile:
            return baseUrl + "/user_register"
            print("Base url : --> \(baseUrl)")
        case .verifyOtp:
           return baseUrl + "/user_verify_otp"
        case .clinicList(let serviceId,let page,let keyword,let latitude,let longitude):
            if latitude.isNotEmpty || longitude.isNotEmpty {
                return serviceId.isEmpty ? baseUrl + "/clinic_listing?page_count=30&page=\(page)&keyword=\(keyword)&latitude=\(latitude)&longitude=\(longitude)" :
                baseUrl + "/clinic_listing?page_count=30&\(serviceId)&page=\(page)&keyword=\(keyword)&latitude=\(latitude)&longitude=\(longitude)"
            }
            else {
                return serviceId.isEmpty ? baseUrl + "/clinic_listing?page_count=30&page=\(page)&keyword=\(keyword)" :
                baseUrl + "/clinic_listing?page_count=30&\(serviceId)&page=\(page)&keyword=\(keyword)"
            }
        case .productList(let categoryId,let page,let keyword):
            return  categoryId.isEmpty  ?   baseUrl + "/get_products?page=\(page)&keyword=\(keyword)" :  baseUrl + "/get_products??page=\(page)&category_filter[]=\(categoryId)&keyword=\(keyword)"
            
        case .slotListing(let clinicId, let day, let time):
            return baseUrl + "/clinic_slot_details?clinic_id=\(clinicId)&day=\(day)&timing=\(time)"
        case .addTocat:
            return baseUrl + "/add_to_cart"
        case .home:
            return baseUrl + "/home"
        case .viewCart:
            return baseUrl + "/view_cart"
        case .updateCart:
            return baseUrl + "/change_quantity_cart"
        case .location:
            return baseUrl + "/location"
        case .saveAddress:
            return baseUrl + "/user_address"
        case .getAddress:
            return baseUrl + "/user_address"
        case .deleteAddress(let id):
            return baseUrl + "/user_address?id=\(id)"
        case .editAddress:
            return baseUrl + "/user_address"
        case .tokenRefresh:
            return baseUrl + "/token_refresh"
        case .productPayment:
            return baseUrl + "/cashfree/create-order"
        case .myOrders:
            return baseUrl + "/view_orders"
        case .addToFavorite:
            return baseUrl + "/favourite"
        case .getProductFavorite:
            return baseUrl + "/favourite?favourited_item=product"
        case .getClinicFavorite:
            return baseUrl + "/favourite?favourited_item=clinic"
        case .deleteFavorite:
            return baseUrl + "/favourite"
        case .clinicPayment:
            return baseUrl + "/cashfree/book-appointment"
        case .myAppointments:
            return baseUrl + "/user_appointments"
        case .similarProducts(let seller):
            return baseUrl + "/get_products?seller_id=\(seller)"
        case .productForYou:
            return baseUrl + "/get_products?similar_products=true"
        case .productReview(let productId):
            return baseUrl + "/view_product_review?pid=\(productId)"
        case .clinicReview(let clinicId):
            return baseUrl + "/view_clinic_review?clinic_id=\(clinicId)"
        case .blogList:
            return baseUrl + "/blogs"
        case .blogDetail(let blogId):
            return baseUrl + "/blog_details/\(blogId)"
        case .addProductReview:
            return baseUrl + "/product_review"
        case .addClinicReview:
            return baseUrl + "/clinic_review"
        case .appointmentCharge:
            return baseUrl + "/get_clinic_appointment_price"
        case .logout:
            return baseUrl + "/user_logout"
        case .delete:
            return baseUrl + "/remove-account"
        case .getAppointmentDetails(let id):
            return baseUrl + "/appointments_details?appointment_id=\(id)"
        case .clinicFilters:
            return baseUrl + "/clinic_filters"
        }
    }
    
    var authRequired : Bool {
        switch self {
        case .registerMobile,.verifyOtp:
            return false
        default:
            return true
        }
    }
    
    var method : HTTPMethod {
        switch self {
        case .viewCart:
            fallthrough
        case .home:
            fallthrough
        case .slotListing:
            fallthrough
        case .getPost:
            fallthrough
        case .getAddress:
            fallthrough
        case .myOrders:
            fallthrough
        case .getProductFavorite:
            fallthrough
        case .getClinicFavorite:
            fallthrough
        case .clinicList:
            return  .get
        case .registerMobile:
            fallthrough
        case  .verifyOtp:
            return .post
        case .productList:
            return .get
        case .location:
            fallthrough
        case .saveAddress:
            fallthrough
        case .appointmentCharge:
            fallthrough
        case .addTocat:
            return .post
        case .updateCart:
            return .put
        case .deleteAddress:
            return .delete
        case .editAddress:
            return .put
        case .tokenRefresh:
            return .post
        case .productPayment:
            return .post
        case .addToFavorite:
            return .post
        case .deleteFavorite:
            return .delete
        case .clinicPayment:
            return .post
        case .myAppointments:
            return .get
        case .similarProducts:
            return .get
        case .productForYou:
            return .get
        case .productReview:
            return .get
        case .clinicReview:
            return .get
        case .blogList:
            return .get
        case .blogDetail:
            return .get
        case .addProductReview:
            return .post
        case .addClinicReview:
            return .post
        case .logout:
            return .post
        case .delete:
            return .post
        case .getAppointmentDetails:
            return .get
        case .clinicFilters:
            return .get
        }
    }
    
}
