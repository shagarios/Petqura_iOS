//
//  ProductDetailsModel.swift
//  PawWalker
//
//  Created by shagar on 12/05/25.
//

struct ProductReviewModel : Codable {
    let message : String?
    let result : ProductReviewResult?
}

struct ProductReviewResult : Codable {
    let averageRating: Double?
    let reviews: [ProductReview]
    let total: Int?
        enum CodingKeys: String, CodingKey {
            case averageRating = "average_rating"
            case reviews, total
        }
}

protocol Review {
    var reviewContent: String?{get}
    var reviewId : String {get}
    var reviewStarCount: Double? {get}
    var reviewTitle: String? {get}
    var timeCreated: String? {get}
    var user: String? {get}
    var userID : String? {get}
}

struct ProductReview : Codable,Review{
    var reviewContent: String?
    var reviewId: String
    var reviewStarCount: Double?
    var reviewTitle: String?
    var timeCreated: String?
    var user: String?
    var userID: String?
    var productID: String?
    var certifiedUser: Bool?
    enum CodingKeys: String, CodingKey {
        case certifiedUser = "certified_user"
        case productID = "product_id"
        case reviewContent = "review_content"
        case reviewId = "review_id"
        case reviewStarCount = "review_star_count"
        case reviewTitle = "review_title"
        case timeCreated = "time_created"
        case user
        case userID = "user_id"
    }
}
