//
//  MyOrdersModel.swift
//  PawWalker
//
//  Created by shagar on 06/04/25.
//

struct MyOrdersModel : Codable {
    let message: String
    let result : MyOrdersResult?
}

struct MyOrdersResult : Codable {
    let orders : [MyOrder]
}

struct MyOrder : Codable,Hashable {
    let brandName: String?
    let quantity: Int?
    let variantName: String?
    let productName: String?
    let sellerName : String?
    let productImage: String?
    let orderPlacedDatetime : String?
    let orderStatus : String?
    let orderDetailID : String
    let productId : String
    enum CodingKeys : String, CodingKey {
        case brandName = "brand_name"
        case quantity
        case variantName = "variant_name"
        case  productName = "product_name"
        case sellerName = "seller_name"
        case productImage = "product_image"
        case orderPlacedDatetime = "order_placed_datetime"
        case orderStatus = "order_status"
        case orderDetailID = "order_details_id"
        case productId = "product_id"
    }
}
