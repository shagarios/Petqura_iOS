//
//  ClnicDetailModel.swift
//  PawWalker
//
//  Created by shagar on 13/05/25.
//

struct ClinicReviewModel : Codable {
    let message : String
    let result : ClinicReviewResult?
}
struct ClinicReviewResult: Codable {
    let averageRating: Double?
    let reviews: [ClinicReview]
    let total: Int

    enum CodingKeys: String, CodingKey {
        case averageRating = "average_rating"
        case reviews, total
    }
}

struct ClinicReview : Codable, Review {
    var reviewContent: String?
    var reviewId: String
    var reviewStarCount: Double?
    var reviewTitle: String?
    var timeCreated: String?
    var user: String?
    var userID: String?
    var clinicID : String?
     let certifiedUser: Bool?
    enum CodingKeys: String, CodingKey {
          case certifiedUser = "certified_user"
          case clinicID = "clinic_id"
          case reviewContent = "review_content"
          case reviewId = "review_id"
          case reviewStarCount = "review_star_count"
          case reviewTitle = "review_title"
          case timeCreated = "time_created"
          case user
          case userID = "user_id"
      }
    
}

