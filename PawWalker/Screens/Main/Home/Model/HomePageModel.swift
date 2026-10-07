//
//  HomePageModel.swift
//  PawWalker
//
//  Created by shagar on 11/02/25.
//

struct HomeModel : Codable {
    let message : String
    let result : HomeData?
}

struct HomeData : Codable {
    let banners: [Banner]
        let categories: [Category]
        let services: [Services]
        let pendingReviews:[PendingReview]
    enum CodingKeys: String, CodingKey {
        case banners
        case categories
        case services
        case pendingReviews = "pending_reviews"
    }
}

// MARK: - Banner
struct Banner: Codable {
    let bannerImage: String?
    let bannerImageMobile: String?
    let bannerText, pages, status: String?

    enum CodingKeys: String, CodingKey {
        case bannerImage = "banner_image"
        case bannerImageMobile = "banner_image_mobile"
        case bannerText = "banner_text"
        case pages, status
    }
}

// MARK: - Category
struct Category: Codable {
    let id : String
    let categoryDescription, categoryName, idealFor: String?
    let isFoodItem: Bool?
    let productCount: Int?
    let icon : String?

    enum CodingKeys: String, CodingKey {
        case categoryDescription = "category_description"
        case categoryName = "category_name"
        case id
        case idealFor = "ideal_for"
        case isFoodItem = "is_food_item"
        case productCount = "product_count"
        case icon
    }
}

// MARK: - Service
struct Services: Codable {
    let description: String?
    let icon: String?
    let id: String
    let status: Int?
    let title: String?
}

struct PendingReview: Codable {
    let id: String
    let entityId: String?
    let entityImage: String?
    let entityName: String?
    let referenceDate: String?
    let referenceDoctor: String?
    let referenceTime: String?
    let type: String?
    let entityQuantity : String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case entityId = "entity_id"
        case entityImage = "entity_image"
        case entityName = "entity_name"
        case referenceDate = "reference_date"
        case referenceDoctor = "reference_doctor"
        case referenceTime = "reference_time"
        case type
        case entityQuantity = "entity_qty"
    }
    var enityType : EntityType {
        return entityQuantity == "clinic" ? .clinic : .product
    }
}
