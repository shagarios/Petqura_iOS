//
//  FavoriteModel.swift
//  PawWalker
//
//  Created by shagar on 06/04/25.
//

import Foundation

enum FavoriteType : String, CaseIterable,Hashable {
    case product
    case clinic
    var displayName : String {
        switch self {
        case .product:
            return TextResource.store
        case .clinic:
            return TextResource.clinic
        }
    }
}

struct FavoriteProductModel : Codable {
    let message : String
    let result : [FavoiteProduct]?
}


struct FavoiteProduct : Codable {
    let id = UUID().uuidString
    let brandName, categoryID, categoryName : String?
        let isFoodItem: Bool?
        let productDescription, productID, productName: String?
        let variants : Variant?
        enum CodingKeys: String, CodingKey {
            case brandName = "brand_name"
            case categoryID = "category_id"
            case categoryName = "category_name"
            case isFoodItem = "is_food_item"
            case productDescription = "product_description"
            case productID = "product_id"
            case productName = "product_name"
            case variants
        }
}

struct FavoriteClinicModel : Codable {
    let message : String
    let result : [FavoriteClinic]?
}

struct FavoriteClinic : Codable {
    let active: Bool
    let clinicID: String?
    let clinicImage: String?
    let clinicName : String?
      enum CodingKeys: String, CodingKey {
          case active
          case clinicID = "clinic_id"
          case clinicImage = "clinic_image"
          case clinicName = "clinic_name"
      }
}
