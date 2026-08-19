//
//  Cart Model.swift
//  PawWalker
//
//  Created by shagar on 10/02/25.
//
import Foundation

struct AddToCartModel : Codable {
    let message : String
    let result : CartResult?
}

struct CartResult : Codable {
    let cart : [CartElement]?
    var gst, orderAmount, orderTotalWithShipping: Double?
    var pointsAvailable, pointsRedeemable, shippingCharge, total: Double?
    var totalAmount: Double?
    var netAmount : Double?
    var canAddToCart : Bool?
    var guestId : String?
    enum CodingKeys: String, CodingKey {
        case cart, gst
        case orderAmount = "order_amount"
        case orderTotalWithShipping = "order_total_with_shipping"
        case pointsAvailable = "points_available"
        case pointsRedeemable = "points_redeemable"
        case shippingCharge = "shipping_charge"
        case total
        case totalAmount = "total_amount"
        case netAmount = "net_price"
        case canAddToCart
        case guestId = "guest_id"
    }
}

struct CartElement : Codable {
    let cartID: String
    let productVariant : Variant?
    let quantity: Int?
    let totalPrice: Double?
    
    enum CodingKeys: String, CodingKey {
        case cartID = "cart_id"
        case productVariant = "product_variant"
        case quantity
        case totalPrice = "total_price"
    }
}

struct BillItem : Identifiable {
    let id = UUID()
    let name : String
    var value : String
}

struct ProductOrderResponse : Codable {
    let response : ProductOrder
}

struct ProductOrder : Codable {
    let orderID : String
    let paymentSessionID : String
    enum CodingKeys : String, CodingKey {
        case orderID =  "order_id"
        case paymentSessionID = "payment_session_id"
    }
}
