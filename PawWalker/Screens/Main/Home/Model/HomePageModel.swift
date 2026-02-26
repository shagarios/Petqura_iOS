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

