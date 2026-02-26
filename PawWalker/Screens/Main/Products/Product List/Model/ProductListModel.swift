//
//  ProductListModel.swift
//  PawWalker
//
//  Created by shagar on 18/01/25.
//

import SwiftUI
struct ProductListModel : Codable {
    let message : String
    let result : ProductList?
}
struct ProductList : Codable {
    let hasNext : Bool
    let products : [Product]
    let total : Int
    enum CodingKeys: String,CodingKey {
        case hasNext = "has_next"
        case products
        case  total
    }
}

struct Product : Codable {
    let active: Bool?
    let addedBy: String?
    let addedByID, brandName, categoryID, categoryName: String?
    let idealFor: String?
    let isFoodItem: Bool?
    let productDescription, productID: String
    let productName: String?
    let variants: [Variant]
    enum CodingKeys: String, CodingKey {
           case active
           case addedBy = "added_by"
           case addedByID = "added_by_id"
           case brandName = "brand_name"
           case categoryID = "category_id"
           case categoryName = "category_name"
           case idealFor = "ideal_for"
           case isFoodItem = "is_food_item"
           case productDescription = "product_description"
           case productID = "product_id"
           case productName = "product_name"
           case variants
       }
}

struct Variant : Codable {
     let active, customDelivery: Bool?
       let customDeliveryDays: Int?
       let deliveryIn24, deliveryIn72: Bool?
       let discountedPrice: Double?
       let dispalyDiscountPercentage, floatPrice: Int?
       let isFoodItem: Bool?
       let isVeg: Bool?
       let netQuantity: String?
      let nonDiscountPrice, price: Double?
       let productImage1: String?
       let productImage2: String?
       let productImage3, productImage4: String?
       let productImage5: String?
       let productName : String
       let productVariantID: String
       let quantityUnit: String?
       let sortOrder: Int?
       let stock, variantName: String?
       let favoriteId : String?
       var isFavorite : Bool?
    enum CodingKeys: String, CodingKey {
            case active
            case customDelivery = "custom_delivery"
            case customDeliveryDays = "custom_delivery_days"
            case deliveryIn24 = "delivery_in_24"
            case deliveryIn72 = "delivery_in_72"
            case discountedPrice = "discounted_price"
            case dispalyDiscountPercentage = "dispaly_discount_percentage"
            case floatPrice = "float_price"
            case isFoodItem = "is_food_item"
            case isVeg = "is_veg"
            case netQuantity = "net_quantity"
            case nonDiscountPrice = "non_discount_price"
            case price
            case productImage1 = "product_image_1"
            case productImage2 = "product_image_2"
            case productImage3 = "product_image_3"
            case productImage4 = "product_image_4"
            case productImage5 = "product_image_5"
            case productName = "product_name"
            case productVariantID = "product_variant_id"
            case quantityUnit = "quantity_unit"
            case sortOrder = "sort_order"
            case stock
            case variantName = "variant_name"
            case favoriteId =  "favourite_id"
            case isFavorite = "is_favourite"
        }
}
