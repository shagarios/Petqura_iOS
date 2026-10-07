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

struct FavouritesResponse: Codable {
    let message: String
    let result: FavoritesResult?
}
 
// MARK: - Result
 
struct FavoritesResult: Codable {
    let favourites: [FavoriteProduct]
    let hasNext: Bool?
    let hasPrev: Bool?
    let page: Int?
    let pages: Int?
    let perPage: Int?
    let total: Int?
 
    enum CodingKeys: String, CodingKey {
        case favourites
        case hasNext = "has_next"
        case hasPrev = "has_prev"
        case page
        case pages
        case perPage = "per_page"
        case total
    }
}
struct FavoriteProduct: Codable, Identifiable {
    let active: Bool?
    let brandName: String?
    let categoryId: String?
    let categoryName: String?
    let idealFor: String?
    let isFoodItem: Bool?
    let productDescription: String?
    let productId: String
    let productName: String?
    let variants: Variant?
 
    /// Convenience conformance to `Identifiable` using the product id.
    var id: String { productId }
 
    enum CodingKeys: String, CodingKey {
        case active
        case brandName = "brand_name"
        case categoryId = "category_id"
        case categoryName = "category_name"
        case idealFor = "ideal_for"
        case isFoodItem = "is_food_item"
        case productDescription = "product_description"
        case productId = "product_id"
        case productName = "product_name"
        case variants
    }
}

struct FavoriteClinicModel : Codable {
    let message : String
    let result : FavoriteClinicResult?
}
struct FavoriteClinicResult : Codable {
    let favourites : [FavoriteClinic]
}

struct FavoriteClinic : Codable {
    let active: Bool
    let clinicID: String
    let clinicImage: String?
    let clinicName : String?
      enum CodingKeys: String, CodingKey {
          case active
          case clinicID = "clinic_id"
          case clinicImage = "clinic_image"
          case clinicName = "clinic_name"
      }
}

struct ClinicSuggetionsModel: Codable {
    let message : String
    let result : ClinicSuggetions
}

struct ClinicSuggetions: Codable {
    let hasNext : Bool?
    let page : Int?
    let pages :Int?
    let suggestions : [Clinic]
    enum CodingKeys: String,CodingKey {
        case hasNext = "has_next"
        case page
        case pages
        case suggestions 
    }
}
