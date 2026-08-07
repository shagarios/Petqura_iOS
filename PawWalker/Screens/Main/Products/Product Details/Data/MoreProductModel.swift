//
//  MoreProductModel.swift
//  PawWalker
//
//  Created by shagar on 31/07/26.
//

struct MoreProductListModel: Codable {
    let message: String
    let result: MoreProductListResult?

    enum CodingKeys: String, CodingKey {
        case message = "message"
        case result = "result"
    }
}

// MARK: - Result
struct MoreProductListResult: Codable {
    let hasNext: Bool
    let hasPrev: Bool
    let page: Int
    let pages: Int
    let perPage: Int?
    let products: [MoreProduct]
    let total: Int?

    enum CodingKeys: String, CodingKey {
        case hasNext = "has_next"
        case hasPrev = "has_prev"
        case page = "page"
        case pages = "pages"
        case perPage = "per_page"
        case products = "products"
        case total = "total"
    }
}

// MARK: - Product
struct MoreProduct: Codable {
    let distanceKM: String?
    let price: Int?
    let productName: String?
    let variantID: String
    let productStore: String?
    let productId: String?

    enum CodingKeys: String, CodingKey {
        case distanceKM = "distance_km"
        case price = "price"
        case productName = "product_name"
        case variantID = "variant_id"
        case productStore = "store_name"
        case productId = "product_id"
    }
}
